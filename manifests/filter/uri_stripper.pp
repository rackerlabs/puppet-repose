# == Resource: repose::filter::uri_stripper
#
# This is a resource for generating uri_stripper configuration files
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure config file is present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String. Filename to output config
# Defaults to <tt>uri-stripper.cfg.xml</tt>
#
# [*rewrite_location*]
# Bool. True to rewrite Location Header with token value stripped from the uri.
# Defaults to <tt>false</tt>
#
# [*token_index*]
# Integer. Index of token in the resource path to strip/remove.  Tokens are parsed using the '/' character as the delimiter.
# Starting from index '0' the URI Stripper will take the element at token_index and remove it from the request path.
# Defaults to <tt>0</tt>
#
# === Links
#
# * https://repose.atlassian.net/wiki/display/REPOSE/URI+Stripper+filter
#
# === Examples
#
# repose::filter::uri_stripper { 'default':
#   ensure           => present,
#   rewrite_location => true,
#   token_index      => 1
# }
#
# === Authors
#
# * Vinny Ly <mailto:vinny.ly@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::uri_stripper (
  $ensure           = present,
  $filename         = 'uri-stripper.cfg.xml',
  $rewrite_location = false,
  $token_index      = 0,
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
    $content_template = template("${module_name}/uri-stripper.cfg.xml.erb")
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
