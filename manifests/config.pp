# == Class: repose::repose9
#
# This class is able to install or remove repose 9 on a node.
#
#
# === Parameters
#
# The default values for the parameters are set in repose::params. Have
# a look at the corresponding <tt>params.pp</tt> manifest file if you need more
# technical information about them.
#
# [*ensure*]
# String. Controls if the managed resources shall be <tt>present</tt> or
# <tt>absent</tt>. If set to <tt>absent</tt>:
# * The managed software packages are being uninstalled.
# * Any traces of the packages will be purged as good as possible. This may
# include existing configuration files. The exact behavior is provider
# dependent. Q.v.:
# * Puppet type reference: {package, "purgeable"}[http://j.mp/xbxmNP]
# * {Puppet's package provider source code}[http://j.mp/wtVCaL]
# * System modifications (if any) will be reverted as good as possible
# (e.g. removal of created users, services, changed log settings, ...).
# * This is thus destructive and should be used with care.
# Defaults to <tt>present</tt>.
#
# The default values for the parameters are set in repose::params. Have
# a look at the corresponding <tt>params.pp</tt> manifest file if you need more
# technical information about them.
#
# [*daemon_home*]
# String. Daemon home path
# Defaults to <tt>/usr/share/lib/repose</tt>
#
# [*log_path*]
# String. Log file directory path
# Defaults to <tt>/var/log/repose</tt>
#
# [*user*]
# String. User to run the valve as
# Defaults to <tt>repose</tt>
#
# [*daemonize*]
# String. the path to the daemonize binary
# Defaults to <tt>/usr/sbin/daemonize</tt>
#
# [*daemonize_opts*]
# String. The daemonize options to be passed into daemonize.
# DEPRECATED. This does nothing for repose 7+. This is replaced by a different
# variable in the sysconfig file but we are not supporting overwriting it.
# at this time.
# Defaults to <tt>-c $DAEMON_HOME -p $PID_FILE -u $USER -o $LOG_PATH/stdout.log -e $LOG_PATH/stderr.log -l /var/lock/subsys/$NAME</tt>
#
# [*java_options*]
# String. Additional java options to pass to java_opts
# NOTE: this also sets JAVA_OPTS for repose 7+
# Defaults to <tt>undef</tt>
#
# [*java_cmd*]
# String. Set java command in sysconfig, if multiple java installations exist
# Defaults to '/usr/bin/java'
#
# [*saxon_home*]
# String. Home directory for Saxon. Sets SAXON_HOME
# Defaults to <tt>undef</tt>
#
# [*log_files*]
# Array. List of log files
# 
# [*rotate_frequency*]
# String. Frequency of log rotation, default 'daily'
# 
# [*rotate_count*]
# Integer. Number of rotations per frequency
# 
# [*compress*]
# Boolean. Compress log backups or not
#
# [*delay_compress*]
# Boolean. Delay compression
# 
# [*use_date_ext*]
# Boolean. Use date as extension
# === Examples
#
# * Installation:
#
# class { 'repose::repose9': }
#
# * Removal/decommissioning:
#
# class { 'repose::repose9': ensure => 'absent' }
#
#
# === Authors
#
# * Josh Bell <mailto:josh.bell@rackspace.com>
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
class repose::config (
) {
  $file_ensure = $repose::ensure ? {
    'absent' => 'absent',
    default  => file,
  }
  $dir_ensure = $repose::ensure ? {
    'absent' => 'absent',
    default  => directory,
  }

## files/directories
  File {
    owner   => $repose::owner,
    group   => $repose::group,
  }

  file { $repose::configdir:
    ensure => $dir_ensure,
    mode   => $repose::dirmode,
  }

  file { '/etc/security/limits.d/repose':
    ensure => $file_ensure,
    source => 'puppet:///modules/repose/limits',
    mode   => $repose::mode,
  }

  file { '/etc/sysconfig/repose':
    ensure => $file_ensure,
    mode   => $repose::mode,
    owner  => root,
    group  => root,
  }

  # default repose valve sysconfig options
  $repose_sysconfig = [
    "set JAVA_CMD ${repose::java_cmd}",
    "set REPOSE_CFG '${repose::configdir}'",
    "set REPOSE_JAR '${repose::daemon_home}/${repose::service_name}.jar'",
    "set DAEMON_HOME '${repose::daemon_home}'",
    "set LOG_PATH '${repose::log_path}'",
    "set USER '${repose::user}'",
    "set daemonize '${repose::daemonize}'",
    "set daemonize_opts '\"${repose::daemonize_opts}\"'",
    "set JAVA_OPTS '\"${repose::java_options}\"'",
  ]

  # if saxon_home provided for saxon license
  if $repose::saxon_home {
    $saxon_sysconfig = [
      "set SAXON_HOME '${repose::saxon_home}'",
      "set SAXON_HOME/export ''",
    ]
  } else {
    $saxon_sysconfig = 'rm SAXON_HOME'
  }

  logrotate::rule { 'repose_logs':
    path          => $repose::log_files,
    rotate        => $repose::rotate_count,
    missingok     => true,
    compress      => $repose::compress,
    delaycompress => $repose::delay_compress,
    dateext       => $repose::use_date_ext,
  }
  augeas {
    'repose_service_unit':
      incl    => '/lib/systemd/system/repose.service',
      lens    => 'Systemd.lns',
      context => '/files/lib/systemd/system/repose.service',
      changes => [
        'rm /files/lib/systemd/system/repose.service/Service/Environment',
        'set Service/EnvironmentFile/value /etc/sysconfig/repose',
      ],
  }
  # only run if ensure is not absent
  if ! ($repose::ensure == 'absent') {
    # run augeas with our changes
    augeas {
      'repose_sysconfig':
        incl    => '/etc/sysconfig/repose',
        require => File['/etc/sysconfig/repose'],
        lens    => 'Shellvars.lns',
        context => '/files/etc/sysconfig/repose',
        changes => [$repose_sysconfig, $saxon_sysconfig],
    }
  }
}
