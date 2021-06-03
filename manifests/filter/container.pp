# == Class: repose::filter::container
#
# This is a class for managing the container configuration file
# and log4j.properties Container configuration is fully documented in the
# Repose project wiki.
# https://repose.atlassian.net/wiki/spaces/REPOSE/pages/527236/Container
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
# [*log_file_perm*]
# String. This option can be used to provide world read access on repose logs.
# if value='private' OR [not equals 'public'] will follow the os umap 
# permission of repose user.
# if value='public' will provide world read access on log files.
# Defaults to <tt>private</tt>
#
# [*log_use_log4j2*]
# Boolean. This option will enable the use of log4j2 xml configuration files.
# This will override <tt>logging_configuration</tt> to use <tt>log4j2.xml</tt>.
# This uses RFC5424 formated syslog messages if syslog enabled. Additional info
# can be parsed out in rsyslog using the mmpstrucdata module.
# http://www.rsyslog.com/doc/master/configuration/modules/mmpstrucdata.html
# Defaults to <tt>false</tt>.
#
# [*log_log4j2_optional_loggers*]
# Hash of Hashes. A Hash of key value pairs where the key is the repose class
# name for a filter and the value is a hash of key value paris of log4j2
# logger fields (level is required, but optional feields can be added. level
# can be one of `off`, `error`, `warn`, `info`, `debug`, and `trace`.
# # Example:
# $log_log4j2_optional_loggers: {
#    "intrafilter-logging"  => { "level" => "trace",},
#    "org.apache.http.wire" => { "level" => "trace", "additivity" => "true",},
#    "org.openrepose"       => { "level" => "debug",},
#  }
# The attribute log_use_log4j2 must be set true for this to modify the correct
# template.
# Note:
# The followg classes loggeers should not be modified as they require more
# advanced configuration than this feature provides and they are handled
# elsewhere. Those classes are: http, org.openrepose.herp.pre.filter and
# org.openrepose.herp.post.filter 
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
# [*ssl_include_protocol*]
# Array [String]. The protocol strings to allow connections for.
# Defaults to <tt>undef</tt>
#
# [*ssl_exclude_protocol*]
# Array [String]. The protocol strings to deny connections for.
# Defaults to <tt>undef</tt>
#
# [*ssl_tls_renegotiation*]
# Boolean. Explicitly allow or deny TLS renegotiation.
# Defaults to <tt>undef</tt>
#
# [*via_header*]
# Hash. Hash containing any or all of the following optional keys:
# request-prefix, response-prefix, and/or repose-version. The keys
# request-prefix and response-prefix are simple Strings, the key repose-version
# is a Boolean. 
# Example:
# via_header = { 'response-prefix' => 'Salad', 'repose-version' => 'false' }
# Defaults to <tt>{}</tt>
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
  String $artifact_directory,
  String $deployment_directory,
  String $log_access_facility,
  String $log_access_app_name,
  Boolean $log_access_local,
  String $log_access_local_name,
  Boolean $log_access_syslog,
  String $log_dir,
  String $log_herp_app_name,
  String $log_herp_facility,
  Boolean $log_herp_flume,
  Boolean $log_herp_syslog,
  String $log_herp_syslog_postfilter,
  String $log_herp_syslog_prefilter,
  Hash $log_log4j2_default_loggers,
  Hash $log_log4j2_optional_loggers,
  Hash $log_log4j2_intrafilter_trace_loggers,
  Boolean $log_intrafilter_trace,
  String $log_level,
  String $log_local_size,
  Integer $log_local_rotation_count,
  String $log_repose_facility,
  String $log_file_perm,
  String $logging_configuration,
  Integer $syslog_port,
  String $syslog_protocol,
  String $flume_host,
  Integer $flume_port,
  Optional[Enum['date','size']] $log_local_policy = undef,
  Enum['present','absent'] $ensure      = 'present',
  Optional[String] $app_name                             = undef,
  Integer $artifact_directory_check_interval    = 60000,
  Optional[Integer] $content_body_read_limit              = undef,
  Boolean $deployment_directory_auto_clean      = true,
  Optional[Integer] $jmx_reset_time                       = undef,
  Boolean $log_use_log4j2                       = false,
  Boolean $ssl_enabled                          = false,
  Optional[String] $ssl_keystore_filename                = undef,
  Optional[String] $ssl_keystore_password                = undef,
  Optional[String] $ssl_key_password                     = undef,
  Optional[Array] $ssl_include_cipher                   = undef,
  Optional[Array] $ssl_exclude_cipher                   = undef,
  Optional[Array] $ssl_include_protocol                 = undef,
  Optional[Array] $ssl_exclude_protocol                 = undef,
  Optional[Boolean] $ssl_tls_renegotiation                = undef,
  Optional[String] $syslog_server                        = undef,
  Hash $via_header                           = {},
) {

### Validate parameters
## ensure
  $file_ensure = $ensure ? {
    present => file,
    absent  => absent,
  }
  if $::debug {
    debug("\$ensure = '${ensure}'")
  }

  if $log_use_log4j2 == true {
    $logging_configuration_real = 'log4j2.xml'
    # also merge logger options hashes. 
    if $log_intrafilter_trace == true {
      $log_log4j2_loggers = deep_merge($log_log4j2_default_loggers, $log_log4j2_optional_loggers, $log_log4j2_intrafilter_trace_loggers)
    } else {
      $log_log4j2_loggers = deep_merge($log_log4j2_default_loggers, $log_log4j2_optional_loggers)
    }
  } else {
    $logging_configuration_real = $logging_configuration
  }

  $logging_configuration_file = "${repose::configdir}/${logging_configuration_real}"
## Manage actions

  if $ensure == 'present' {
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
    owner   => $repose::owner,
    group   => $repose::group,
    mode    => $repose::mode,
    require => Class['::repose::package'],
  }

  file { $logging_configuration_file:
    content => $log4j_content_template
  }

  file { "${repose::configdir}/container.cfg.xml":
    content => $container_content_template
  }

}
