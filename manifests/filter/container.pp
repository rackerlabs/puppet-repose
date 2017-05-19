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
# [*artifact_directory*]
# String.
# Defaults to <tt>/usr/share/repose/filters</tt>
#
# [*artifact_directory_check_interval*]
# Integer. Directory check interval in milliseconds.
# Defaults to <tt>60000</tt>
#
# [*client_request_logging*]
# Bool. Logs communication between repose and the end service. Depreciated in
# Repose version 8 and above, must not be set. 
# Defaults to <tt>undef</tt>
#
# [*content_body_read_limit*]
# Integer. Maximum size ofr request content in bytes
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
# [*jmx_reset_time*]
# Integer. The number of seconds the JMX reporting service keeps
# data. The data will be reset after this amount of time.
# Defaults to <tt>undef</tt>
#
# [*log_access_facility*]
# String. The facility to use when sending access logs via syslog.
# Defaults to <tt>local1</tt>
#
# [*log_access_app_name*]
# String. This is the app name to be sent to syslog as part of the RFC5424
# message format. This defaults to blank.
# Defaults to <tt></tt>.
#
# [*log_access_local*]
# Boolean. Should repose access logs be logged locally. Uses the log_local_*
# Settings to determine retention policy.
# Defaults to <tt>true</tt>
#
# [*log_access_local_name*]
# String. The name of the local log file to be created for the local http
# access logs. The name is appended with .log.
# Defaults to <tt>http_repose</tt>
#
# [*log_access_syslog*]
# Boolean. Should repose access logs be to a syslog. Uses the syslog_*
# Settings to determine where to send the logs. You must also specify
# a syslog_server in order for this to be enabled.
# Defaults to <tt>true</tt>
#
# [*log_dir*]
# String. Log file directory
# Defaults to <tt>/var/log/repose</tt>
#
# [*log_level*]
# String. Default log level
# Defaults to <tt>WARN</tt>
#
# [*log_local_policy*]
# String. Log policy for repose.log and http_access.log.  Default setting uses
# the log4j DailyRollingFileAppender with a suffix of .yyyy-MM-dd.  Can be one
# of <tt>date</tt>,<tt>size</tt>,<tt>undef</tt>.  If set to size, the logs
# are rotated based on size and use the <tt>log_local_size</tt> and
# <tt>log_local_rotation_count</tt> for determining retention.  If set to
# <tt>undef</tt> or anything other than <tt>date</tt> or <tt>size</tt>
# the NullAppender is used which means it won't log.
# Defaults to <tt>date</tt>
#
# [*log_local_size*]
# String. The max file size for the log4j RollingFileAppender.
# Defaults to <tt>100MB</tt>
#
# [*log_local_rotation_count*]
# Integer. The number of backup files to keeo for the log4j RollingFileAppender
# Defaults to <tt>4</tt>
#
# [*log_repose_facility*]
# String. The logging facility to send repose logs to when sending to a syslog
# server.
# Defaults to <tt>local0</tt>
#
# [*log_use_log4j2*]
# Boolean. This option will enable the use of log4j2 xml configuration files.
# This will override <tt>logging_configuration</tt> to use <tt>log4j2.xml</tt>.
# This uses RFC5424 formated syslog messages if syslog enabled. Additional info
# can be parsed out in rsyslog using the mmpstrucdata module.
# http://www.rsyslog.com/doc/master/configuration/modules/mmpstrucdata.html
# Defaults to <tt>false</tt>.
#
# [*log_intrafilter_trace*]
# Boolean. Adds intrafilter trace logging to repose - log_use_log4j2 must also
# be set true.
# Defaults to <tt>false</tt>
#
# [*logging_configuration*]
# String. The name of the logging configuration file.
# Defaults to <tt>log4j.properties</tt>
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
# [*ssl_include_cipher*]
# Array [String]. The cipher strings to allow connections for.
# Defaults to <tt>undef</tt>
#
# [*ssl_exclude_cipher*]
# Array [String]. The cipher strings to deny connections for.
# Defaults to <tt>undef</tt>
#
# [*via*]
# String. String used in the Via header.
# Defaults to <tt>undef</tt>
#
# [*log_herp_flume*]
# Enable herp filter publishing to flume.
# Defaults to <tt>false</tt>
#
# [*log_herp_facility*]
# String. The logging facility to send herp logs to when sending to a syslog
# server.
# Defaults to <tt>local2</tt>
#
# [*log_herp_app_name*]
# String. This is the app name to be sent to syslog as part of the RFC5424
# message format. This defaults to blank.
# Defaults to <tt></tt>.
#
# [*log_herp_syslog_prefilter*]
# String. The name of the Logger used to send prefiltered herp logs to syslog.
# This should match the pre_filter_logger_name parameter set for the
# highly_efficient_record_processor filter.
# Defaults to <tt>herp_syslog_prefilter</tt>.
#
# [*log_herp_syslog_postfilter*]
# String. The name of the Logger used to send postfiltered herp logs to syslog.
# This should match the post_filter_logger_name parameter set for the
# highly_efficient_record_processor filter.
# Defaults to <tt>herp_syslog_postfilter</tt>.
#
# [*log_herp_syslog*]
# Enable herp filter publishing to syslog.
# Defaults to <tt>false</tt>
#
# [*flume_host*]
# The hostname of the flume server.
# Defaults to <tt>localhost</tt>
#
# [*flume_port*]
# The port which the flume server is listening on.
# Defaults to <tt>10000</tt>
#
# [*herp*]
# DEPRECATED. Use log_herp_flume. Enable herp filter publishing to flume.
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
# http-connection-pool configuration. Must not be used with Repose 8 and above.
#
# [*read_timeout*]
# DEPRECATED. This attribute is deprecated and moved to the
# http-connection-pool configuration. Must not be used with Repose 8 and above.
#
# [*proxy_thread_pool*]
# DEPRECATED. This attribute is deprecated and moved to the
# http-connection-pool configuration. Must not be used with Repose 8 and above.
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
  $artifact_directory                = $repose::params::artifact_directory,
  $artifact_directory_check_interval = 60000,
  $client_request_logging            = undef,
  $content_body_read_limit           = undef,
  $deployment_directory              = $repose::params::deployment_directory,
  $deployment_directory_auto_clean   = true,
  $jmx_reset_time                    = undef,
  $log_access_facility               = $repose::params::log_access_facility,
  $log_access_app_name               = $repose::params::log_access_app_name,
  $log_access_local                  = $repose::params::log_access_local,
  $log_access_local_name             = $repose::params::log_access_local_name,
  $log_access_syslog                 = $repose::params::log_access_syslog,
  $log_dir                           = $repose::params::logdir,
  $log_herp_app_name                 = $repose::params::log_herp_app_name,
  $log_herp_facility                 = $repose::params::log_herp_facility,
  $log_herp_flume                    = $repose::params::log_herp_flume,
  $log_herp_syslog                   = $repose::params::log_herp_syslog,
  $log_herp_syslog_postfilter        = $repose::params::log_herp_syslog_postfilter,
  $log_herp_syslog_prefilter         = $repose::params::log_herp_syslog_prefilter,
  $log_intrafilter_trace             = $repose::params::log_intrafilter_trace,
  $log_level                         = $repose::params::log_level,
  $log_local_policy                  = $repose::params::log_local_policy,
  $log_local_size                    = $repose::params::log_local_size,
  $log_local_rotation_count          = $repose::params::log_local_rotation_count,
  $log_repose_facility               = $repose::params::log_repose_facility,
  $log_use_log4j2                    = false,
  $logging_configuration             = $repose::params::logging_configuration,
  $ssl_enabled                       = false,
  $ssl_keystore_filename             = undef,
  $ssl_keystore_password             = undef,
  $ssl_key_password                  = undef,
  $ssl_include_cipher                = undef,
  $ssl_exclude_cipher                = undef,
  $syslog_server                     = undef,
  $syslog_port                       = $repose::params::syslog_port,
  $syslog_protocol                   = $repose::params::syslog_protocol,
  $via                               = undef,
  $flume_host                        = $repose::params::flume_host,
  $flume_port                        = $repose::params::flume_port,
  # BELOW ARE DEPRECATED
  $herp                              = false,
  $http_port                         = undef,
  $https_port                        = undef,
  $connection_timeout                = undef,
  $read_timeout                      = undef,
  $proxy_thread_pool                 = undef,
) inherits repose::params {

### Validate parameters
  validate_bool($log_access_local)
  validate_bool($log_access_syslog)
  validate_bool($log_use_log4j2)
  validate_string($log_access_facility)
  validate_string($log_dir)
  validate_string($log_level)
  validate_string($log_access_local_name)
  validate_string($log_repose_facility)
  if ($ssl_include_cipher != undef) {
    validate_array($ssl_include_cipher)
  }
  if ($ssl_exclude_cipher != undef) {
    validate_array($ssl_exclude_cipher)
  }

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

  if $log_use_log4j2 == true {
    $logging_configuration_real = 'log4j2.xml'
  } else {
    $logging_configuration_real = $logging_configuration
  }

  $logging_configuration_file = "${repose::params::configdir}/${logging_configuration_real}"
## Manage actions

  if $ensure == present {
## app_name
    if $app_name == undef {
      fail('app_name is a required parameter')
    }
    if $log_use_log4j2 == true {
        $log4j_content_template = template("${module_name}/log4j2.xml.erb")
    } else {
        $log4j_content_template = template("${module_name}/log4j.properties.erb")
    }
    $container_content_template = template("${module_name}/container.cfg.xml.erb")
  } else {
    $log4j_content_template = undef
    $container_content_template = undef
  }

  File {
    ensure  => $file_ensure,
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Class['::repose::package'],
  }

  file { $logging_configuration_file:
    content => $log4j_content_template
  }

  file { "${repose::params::configdir}/container.cfg.xml":
    content => $container_content_template
  }

}
