# == Resource: repose::filter::keystone_v2
#
# This is a resource for generating keystone-v2 configuration files.
# Only usable in >= 8.0.0.0
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure config file is present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String. Filename to output config
# Defaults to <tt>keystone-v2.cfg.xml</tt>
#
# [*uri*]
# Required. Uri for the keystone endpoint.
#
# [*connection_pool_id*]
# String. The name of a pool from http-connection-pool.cfg.xml. Setting this
# tells the connection pool service to map to the pool with specified id. If
# default is chosen, the default connection pool configurations in connection
# pool service is used.
# Defaults to <tt>undef</tt>
#
# [*send_roles*]
# String containing values 'true' or 'false'
# If undef, defaults to 'true'
#
# [*send_groups*]
# String containing values 'true' or 'false'
# If undef, defaults to 'true'
#
# [*send_catalog*]
# String containing values 'true' or 'false'
# If undef, defaults to 'false'
#
# [*apply_rcn_roles*]
# String containing values 'true' or 'false'
# If undef, defaults to 'false'
#
# [*delegating*]
# Bool. This replaces delagable in repose 7+.
# Defaults to <tt>undef</tt>
#
# [*delegating_quality*]
# Set the quality for this filter when returning error responses.
# Default is <tt>undef</tt> (repose default is 0.7)
#
# [*white_lists*]
# Array contianing uri regexes to white list
#
# [*cache_variability*]
# Integer as String.
# Defaults to <tt>0</tt>
#
# [*token_cache_timeout*]
# Integer as String.
# Defaults to <tt>600</tt>
#
# [*group_cache_timeout*]
# Integer as String.
# Defaults to <tt>600</tt>
#
# [*endpoints_cache_timeout*]
# Integer as String.
# Defaults to <tt>600</tt>
#
# [*atom_feed_id*]
# String. The name of a feed from atom-feed-service.cfg.xml. Setting this
# tells the filter to listen to the configured feed for user events
# and remove matching items from the cache.
# Defaults to <tt>undef</tt>
#
# [*send_all_tenant_ids*]
# Bool. Set to true to receive a list of all tenant ids associated with a token
# from identity.
# Defaults to <tt>undef</tt>, which indicates false
#
# [*tenant_regexs*]
# Client mapping regexs for tenanted mode. Prior to 8.6.3.0 only one is allwoed.
#
# [*legacy_roles_mode*]
# Determines whether or not to send all role tenant ids associated with a user.
# Default is true when undefined, but will change in repose > 9.0.0.0
#
# [*send_tenant_quality*]
# Determines whether to apply qualities to the tenant ids based on where it originates.
#
# [*default_tenant_quality*]
# If sending tenant qualities, what quality to apply to the users default tenant.
# Default is 0.9
#
# [*uri_tenant_quality*]
# If sending tenant qualities, what quality to apply to the users uri tenant.
# Default is 0.7
#
# [*roles_tenant_quality*]
# If sending tenant qualities, what quality to apply to the users role tenants.
# Default is 0.5
#
# [*endpoint_url*]
# Turns on endpoint catalog checking, and requires the given url.
#
# [*endpoint_region*]
# The region that must match the user's endpoint in their catalog. Optional.
#
# [*endpoint_name*]
# The name that must match the user's endpoint in their catalog. Optional.
#
# [*endpoint_type*]
# The type that must match the user's endpoint in their catalog. Optional.
#
# [*pre_authorized_roles*]
# Array containing roles to exclude from restrictions
#
# === Links
#
# * http://www.openrepose.org/versions/latest/filters/keystone-v2.html
#
# === Examples
#
# repose::filter::client_auth_n {
#   'default':
#     auth => {
#       user => 'test',
#       pass => 'testpass',
#       uri => 'testuri',
#     },
#     client_maps => [ '.*/events/(\d+)', ],
# }
#
# === Authors
#
# * Adrian George <mailto:adrian.george@rackspace.com>
#
define repose::filter::keystone_v2 (
  $ensure                  = present,
  $filename                = 'keystone-v2.cfg.xml',
  $uri                     = undef,
  $connection_pool_id      = undef,
  $send_roles              = undef,
  $send_groups             = undef,
  $send_catalog            = undef,
  $apply_rcn_roles         = undef,
  $delegating              = undef,
  $delegating_quality      = undef,
  $white_lists             = undef,
  $cache_variability        = undef,
  $token_cache_timeout     = undef,
  $group_cache_timeout     = undef,
  $endpoints_cache_timeout = undef,
  $atom_feed_id            = undef,
  $send_all_tenant_ids     = undef,
  $tenant_regexs           = undef,
  $legacy_roles_mode       = undef,
  $send_tenant_quality     = undef,
  $default_tenant_quality  = undef,
  $uri_tenant_quality      = undef,
  $roles_tenant_quality    = undef,
  $endpoint_url            = undef,
  $endpoint_region         = undef,
  $endpoint_name           = undef,
  $endpoint_type           = undef,
  $pre_authorized_roles    = undef,
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
    ## uri
    if $uri == undef {
      fail('uri is a required parameter')
    }

    if ($send_tenant_quality == false) and (($default_tenant_quality != undef) or ($uri_tenant_quality != undef) or ($roles_tenant_quality != undef)) {
      fail("setting tenant quality levels doesn't work when tenant qualities is turned off")
    }

    if (($endpoint_name != undef) or ($endpoint_region != undef) or ($endpoint_type != undef)) and ($endpoint_url == undef) {
      fail('endpoint_url is required when doing endpoint catalog checks')
    }

    $content_template = template("${module_name}/keystone-v2.cfg.xml.erb")
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
