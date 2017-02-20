# == Resource: repose::filter::ip_user
#
# This is a resource for generating ip identity configuration files
#
# === Parameters
#
# [*ensure*]
# Bool.  Ensure config file present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String.  Config filename
# Defaults to <tt>ip-user.cfg.xml</tt>
#
# [*quality*]
# Float, floating point numeral from 0.1-1.0 
# Defaults to <tt>0.2</tt>
#
# [*filter_groups*]
# Array of hashes each hash has keys of name (String) and addresses (array
# of CIDR addresses)
# Defaults to <tt>undef</tt>
#
# [*group_header*]
# String, Header name for the group header, Repose defaults this to
#  X-PP-Group if it not defined here.
# Defaults to <tt>undef</tt>
#
# [*user_header*]
# String, Header name for the user header, Repose defaults this to
# X-PP-User if it not defined here.
# Defaults to <tt>undef</tt>
#
# === Links
#
# * http://wiki.openrepose.org/display/REPOSE/IP+Identity
#
# === Examples
#
# repose::filter::ip_user {
#   'default':
#     quality => 0.2,
#     filter_groups => [
#       { "name" => "match_all", "addresses" => [ '0.0.0.0/0', '0::0/0' ] },
#     ]
# }
#
# === Authors
#
# * Josh Bell <nailto:josh.bell@rackspace.com>
# * c/o Cloud Identity Ops <mailto:identityops@rackspace.com>
#
define repose::filter::ip_user (
  $ensure        = present,
  $filename      = 'ip-user.cfg.xml',
  $filter_groups = undef,
  $group_header  = undef,
  $quality       = 0.2,
  $user_header   = undef,
) {

### Validate parameters

## ensure
  if ! ($ensure in [ present, absent ]) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
  } else {
    $file_ensure = $ensure ? {
      present => file,
      absent  => absent,
    }
  }
  if $::debug {
    debug("\$ensure = '${ensure}'")
  }

  if $ensure == present {
#filter_groups
    if $filter_groups == undef {
      fail('filter_groups is a required parameter. see documentation for details.')
    }
    $content_template = template("${module_name}/ip-user.cfg.xml.erb")
  } else {
    $content_template = undef
  }

## Manage actions

  file { "${repose::params::configdir}/${filename}":
    ensure  => $file_ensure,
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Class['::repose::package'],
    content => $content_template
  }

}