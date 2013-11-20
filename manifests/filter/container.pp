# == Class: repose::filter::container
#
# This is a class for managing the container configuration file
# and log4j.properties
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure configuraiton file is present/absent.
# Defaults to <tt>present</tt>
#
# [*app_name*]
# String. Application name. Required
# Defaults to <tt>undef</tt>
#
# [*log_dir*]
# String. Log file directory
# Defaults to <tt>/var/log/repose</tt>
#
# [*log_level*]
# String. Default log level
# Defaults to <tt>WARN</tt>
#
# [*client_request_logging*]
# Bool. Log the client request
# Defaults to <tt>false</tt>
#
# === Examples
#
# class { 'repose::filter::container':
#   app_name => 'repose',
# }
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
class repose::filter::container (
  $ensure                 = present,
  $app_name               = undef,
  $log_dir                = $repose::params::logdir,
  $log_level              = 'WARN',
  $client_request_logging = false,
) inherits repose::params {

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

## app_name
  if $app_name == undef {
    fail('app_name is a required parameter')
  }

## Manage actions

  File {
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Package['repose-filters'],
  }

  file { "${repose::params::configdir}/log4j.properties":
    ensure  => file,
    content => template('repose/log4j.properties.erb')
  }

  file { "${repose::params::configdir}/container.cfg.xml":
    ensure  => file,
    content => template('repose/container.cfg.xml.erb')
  }

}
