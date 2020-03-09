# == Resource: repose::filter::keystone_v2_basic_auth
#
# This is a resource for generating keystone-v2-basic-auth configuration
# files. This supersedes rackspace_identity_basic_auth as of Repose 8.0.0.0.
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure config file is present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String. Filename to output config
# Defaults to <tt>keystone-v2-basic-auth.cfg.xml</tt>
#
# [*identity_service_url*]
# String. Url to the identity endpoint to use for this filter.
# Defaults to <tt>undef</tt>
#
# [*token_cache_timeout*]
# Integer. Time to cache the token in milliseconds
# Defaults to <tt>undef</tt> (repose default is 600000)
#
# [*connection_pool_id*]
# String. The name of a pool from http-connection-pool.cfg.xml. Setting this
# tells the connection pool service to map to the pool with specified id. If
# default is chosen, the default connection pool configurations in connection
# pool service is used.
# Defaults to <tt>undef</tt>
#
# [*secret_type*]
# String. Determines how authentication should be attempted. Valid values are api-key and password.
# Defaults to <tt>undef</tt> (repose defaults to api-key)
#
# [*delegating*]
# Enable delegating mode to allow the herp/derp filters to publish
# rejected requests to flume.
# Defaults to <tt>undef</tt> (repose default is false)
#
# [*delegating_quality*]
# Set the quality for this filter when returning error responses.
# Default is <tt>undef</tt> (repose default is 0.9)
#
# === Links
#
# * http://www.openrepose.org/versions/latest/filters/keystone-v2-basic-auth.html
# * https://repose.atlassian.net/wiki/display/REPOSE/Rackspace+Identity+Basic+Authentication+filter
#
# === Examples
#
# repose::filter::keystone_v2_basic_auth {
#   'default':
# }
#
# === Authors
#
# * Adrian George <mailto:adrian.george@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::keystone_v2_basic_auth (
  $ensure               = present,
  $filename             = 'keystone-v2-basic-auth.cfg.xml',
  $identity_service_url = undef,
  $token_cache_timeout  = undef,
  $connection_pool_id   = undef,
  $secret_type          = undef,
  $delegating           = undef,
  $delegating_quality   = undef,
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

    if ($secret_type != undef) and (! ($secret_type in [api-key, password])) {
      fail('secret_type must have a value of api-key or password')
    }

    $content_template = template("${module_name}/keystone-v2-basic-auth.cfg.xml.erb")
  } else {
    $content_template = undef
  }

## Manage actions

  file { "${repose::configdir}/${filename}":
    ensure  => $file_ensure,
    owner   => $repose::owner,
    group   => $repose::group,
    mode    => $repose::mode,
    require => Class['::repose::package'],
    content => $content_template
  }

}
