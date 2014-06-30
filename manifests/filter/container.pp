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
# [*syslog_server*]
# String.  If this host is provided, the repose log4j configuration will ship
# the repose.log to syslog (facility LOCAL0) and a http logger is created
# for the SLF5J http logger filter (facility LOCAL1).
# Defaults to <tt>undef</tt> which will disable syslog sending.
#
# [*syslog_port*]
# Integer. Port to send syslog traffic to.
# Defaults to <tt>514</tt>
#
# [*syslog_protocol*]
# String. The protocol to send syslog traffic as. Should be 'tcp' or 'udp'.
# Defaults to <tt>udp</tt>
#
# [*via*]
# String. String used in the Via header.
# Defaults to <tt>undef</tt>
#
# [*deployment_directory*]
# String. A string that points the directory where artifacts are extracted.
# Defaults to <tt>/var/repose</tt>
#
# [*deployment_directory_auto_clean*]
# Boolean. Set to true to clean up undeployed resources.
# Defaults to <tt>true</tt>
#
# [*artifact_directory*]
# String.
# Defaults to <tt>/usr/share/repose/filters</tt>
#
# [*artifact_directory_check_interval*]
# Integer. Directory check interval in milliseconds.
# Defaults to <tt>60000</tt>
#
# [*logging_configuration*]
# String. The name of the logging configuration file.
# Defaults to <tt>log4j.properties</tt>
#
# [*ssl_enabled*]
# Boolean. Enable ssl configuration for the container.
# Defaults to <tt>false</tt>
#
# [*ssl_keystore_filename*]
# String. The name of the application keystore file, e.g. keystore.repose
# Defaults to <tt>undef</tt>
#
# [*ssl_keystore_password*]
# String. The password for the entire application keystore
# Defaults to <tt>undef</tt>
#
# [*ssl_key_password*]
# String. The password for the particular application key in the keystore.
# Defaults to <tt>undef</tt>
#
# [*content_body_read_limit*]
# Integer. Maximum size ofr request content in bytes
# Defaults to <tt>undef</tt>
#
# [*jmx_reset_time*]
# Integer. The number of seconds the JMX reporting service keeps
# data. The data will be reset after this amount of time.
# Defaults to <tt>undef</tt>
#
# [*client_request_logging*]
# Bool. Logs communication between repose and the end service
# Defaults to <tt>false</tt>
#
# [*http_port*]
# DEPRECATED. This attribute is deprecated and will be ignored. This has
# moved to the system-model configuration.
#
# [*https_port*]
# DEPRECATED. This attribute is deprecated and will be ignored. This has
# moved to the system-model configuration.
#
# [*connection_timeout*]
# DEPRECATED. This attribute is deprecated and moved to the
# http-connection-pool configuration.
#
# [*read_timeout*]
# DEPRECATED. This attribute is deprecated and moved to the
# http-connection-pool configuration.
#
# [*proxy_thread_pool*]
# DEPRECATED. This attribute is deprecated and moved to the
# http-connection-pool configuration.
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
  $ensure                            = present,
  $app_name                          = undef,
  $log_dir                           = $repose::params::logdir,
  $log_level                         = $repose::params::log_level,
  $syslog_server                     = undef,
  $syslog_port                       = $repose::params::syslog_port,
  $syslog_protocol                   = $repose::params::syslog_protocol,
  $via                               = undef,
  $deployment_directory              = $repose::params::deployment_directory,
  $deployment_directory_auto_clean   = true,
  $artifact_directory                = $repose::params::artifact_directory,
  $artifact_directory_check_interval = 60000,
  $logging_configuration             = $repose::params::logging_configuration,
  $ssl_enabled                       = false,
  $ssl_keystore_filename             = undef,
  $ssl_keystore_password             = undef,
  $ssl_key_password                  = undef,
  $content_body_read_limit           = undef,
  $jmx_reset_time                    = undef,
  $client_request_logging            = undef,
  $http_port                         = undef,
  $https_port                        = undef,
  $connection_timeout                = undef,
  $read_timeout                      = undef,
  $proxy_thread_pool                 = undef,
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

  file { "${repose::params::configdir}/${logging_configuration}":
    ensure  => file,
    content => template('repose/log4j.properties.erb')
  }

  file { "${repose::params::configdir}/container.cfg.xml":
    ensure  => file,
    content => template('repose/container.cfg.xml.erb')
  }

}
