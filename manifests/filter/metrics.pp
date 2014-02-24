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
# === Links
#
# * https://repose.atlassian.net/wiki/display/REPOSE/JMX+Metrics
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

  ## Manage actions

  file { "${repose::params::configdir}/${filename}":
    ensure  => file,
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Package['repose-filters'],
    content => template('repose/metrics.cfg.xml.erb'),
  }    
}