# == Resource:  repose::filter::metrics
#
# This is a resource for enabling emitting metrics to a graphite server.
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure config file present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String. Config filename.
# Defaults to <tt>metrics.cfg.xml</tt>
#
# [*app_name*]
# String. Application name
# Defaults to <tt>repose</tt>
#
# [*graphite_servers*]
# Lists containing host, port, period, prefix
# Defaults to <tt>undef</tt>
#
# [*period*]
# Interval in seconds between sending data to the graphite server
# Defaults to <tt>60</tt>
#
# [*prefix*]
# Graphite prefix for the JMX data item
# Defaults to <tt>''</tt>
#
# [*enabled*]
# Enable repose to report metrics
# Defaults to <tt>true</tt>
#
# === Links
#
# * https://repose.atlassian.net/wiki/display/REPOSE/JMX+Metrics
#
# === Examples
#
# repsoe::filter::metrics {
#  'metrics':
#     graphite_servers => [
#       {
#         'host'    => 'graphite.staging.ord1.us.ci.rackspace.net',
#         'port'    => 2013,
#         'period'  => 10,
#         'prefix'  => 'test/1/metrics',
#         'enabled' => true
#       },
#     ]
# }
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::metrics (
  $ensure           = present,
  $filename         = 'metrics.cfg.xml',
  $app_name         = 'repose',
  $graphite_servers = undef,
  $period           = 60,
  $prefix           = '',
  $enabled          = true,
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
## graphite_servers
    if $graphite_servers == undef {
      fail( 'graphite_servers is a required item' )
    }

## enabled
    validate_bool($enabled)
    $content_template = template("${module_name}/metrics.cfg.xml.erb")
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
