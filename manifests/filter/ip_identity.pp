# == Resource: repose::filter::ip_identity
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
# Defaults to <tt>ip-identity.cfg.xml</tt>
#
# [*quality*]
# List of filters by name, which conains a list of headers
# Defaults to <tt>0.2</tt>
#
# [*whitelist*]
# Hash of quality and an array of addresses
# Defaults to <tt>undef</tt>
#
# === Links
#
# * http://wiki.openrepose.org/display/REPOSE/IP+Identity
#
# === Examples
#
# repose::filter::ip_identity {
#   'default':
#     quality => 0.2,
#     whitelist => {
#       quality => 0.3,
#       addresses => [ '127.0.0.1' ],
#     }
# }
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::ip_identity (
  $ensure    = present,
  $filename  = 'ip-identity.cfg.xml',
  $quality   = 0.2,
  $whitelist = undef,
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
##whitelist
    if $whitelist == undef {
      fail('whitelist is a required parameters. see documentation for details.')
    }
    $content_template = template("${module_name}/ip-identity.cfg.xml.erb")
  } else {
    $content_template = undef
  }

## Manage actions

  file { "${repose::params::configdir}/${filename}":
    ensure  => $file_ensure,
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Package['repose-filters'],
    content => $content_template
  }

}
