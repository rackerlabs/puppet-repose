# == Resource: repose::filter::rackspace_identity_basic_auth
#
# This is a resource for generating rackspace-identity-basic-auth configuration
# files
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure config file is present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String. Filename to output config
# Defaults to <tt>rackspace-identity-basic-auth.cfg.xml</tt>
#
# [*identity_service_url*]
# String. Url to the identity endpoint to use for this filter.
# Defaults to <tt>https://identity.api.rackspacecloud.com/v2.0/tokens</tt>
#
# [*token_cache_timeout*]
# Integer. Time to cache the token in milliseconds
# Defaults to <tt>600000</tt>
#
# [*delegating*]
# Enable delegating mode to allow the herp/derp filters to publish
# rejected requests to flume.
# Defaults to <tt>false</tt>
#
# === Links
#
# * https://repose.atlassian.net/wiki/display/REPOSE/Rackspace+Identity+Basic+Authentication+filter
#
# === Examples
#
# repose::filter::rackspace_identity_basic_auth {
#   'default':
# }
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::rackspace_identity_basic_auth (
  $ensure               = present,
  $filename             = 'rackspace-identity-basic-auth.cfg.xml',
  $identity_service_url = 'https://identity.api.rackspacecloud.com/v2.0/tokens',
  $token_cache_timeout  = '600000',
  $delegating           = false,
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
## auth
    if $identity_service_url == undef {
      fail('identity_service_url is a required parameter')
    }
    $content_template = template("${module_name}/rackspace-identity-basic-auth.cfg.xml.erb")
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
