# == Class: repose::valve
#
# This class is able to install or remove repose-valve on a node.
#
#
# === Parameters
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
# [*enable*]
# Bool/String. Controls if the managed service shall be running(<tt>true</tt>),
# stopped(<tt>false</tt>), or <tt>manual</tt>. This affects the service state
# at both boot and during runtime.  If set to <tt>manual</tt> Puppet will
# ignore the state of the service.
# Defaults to <tt>true</tt>.
#
# [*autoupgrade*]
# Boolean. If set to <tt>true</tt>, any managed package gets upgraded
# on each Puppet run when the package provider is able to find a newer
# version than the present one. The exact behavior is provider dependent.
# Q.v.:
# * Puppet type reference: {package, "upgradeable"}[http://j.mp/xbxmNP]
# * {Puppet's package provider source code}[http://j.mp/wtVCaL]
# Defaults to <tt>false</tt>.
#
# The default values for the parameters are set in repose::params. Have
# a look at the corresponding <tt>params.pp</tt> manifest file if you need more
# technical information about them.
#
# [*run_port*]
# Integer.  The port the valve should run on
# Defaults to <tt>9090</tt>
#
# [*shutdown_port*]
# Integer. The port to listen on for shutdown
# Defaults to <tt>8188</tt>
#
# [*daemon_home*]
# String. Daemon home path
# Defaults to <tt>/usr/share/lib/repose</tt>
#
# [*log_path*]
# String. Log file directory path
# Defaults to <tt>/var/log/repose</tt>
#
# [*pid_file*]
# String. Pid file location
# Defaults to <tt>/var/run/repose-valve.pid</tt>
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
# Defaults to <tt>-c $DAEMON_HOME -p $PID_FILE -u $USER -o $LOG_PATH/stdout.log -e $LOG_PATH/stderr.log -l /var/lock/subsys/$NAME</tt>
#
# [*run_opts*]
# String. The options sent to the run command
# Defaults to <tt>-s $SHUTDOWN_PORT -p $RUN_PORT -c $CONFIG_DIRECTORY</tt>
#
# [*java_options*]
# String. Additional java options to pass to java_opts 
# Defaults to <tt>undef</tt>
#
# [*saxon_home*]
# String. Home directory for Saxon. Sets SAXON_HOME
# Defaults to <tt>undef</tt>
#
# === Examples
#
# * Installation:
#
# class { 'repose::valve': }
#
# * Removal/decommissioning:
#
# class { 'repose::valve': ensure => 'absent' }
#
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
class repose::valve (
  $ensure          = $repose::params::ensure,
  $enable          = $repose::params::enable,
  $autoupgrade     = $repose::params::autoupgrade,
  $run_port        = $repose::params::run_port,
  $shutdown_port   = $repose::params::shutdown_port,
  $daemon_home     = $repose::params::daemon_home,
  $log_path        = $repose::params::logdir,
  $pid_file        = $repose::params::pid_file,
  $user            = $repose::params::user,
  $daemonize       = $repose::params::daemonize,
  $daemonize_opts  = $repose::params::daemonize_opts,
  $run_opts        = $repose::params::run_opts,
  $java_options    = undef,
  $saxon_home      = undef,
) inherits repose::params {

  class { 'repose':
    ensure      => $ensure,
    enable      => $enable,
    autoupgrade => $autoupgrade,
    container   => 'valve',
  }

  file { '/etc/sysconfig/repose':
    ensure  => file,
    owner   => root,
    group   => root,
    require => [ Package[$repose::params::valve_package] ],
    notify  => Service[$repose::params::service],
  }

  # setup augeas with our shellvars lense
  Augeas {
    incl => '/etc/sysconfig/repose',
    require => File['/etc/sysconfig/repose'],
    lens => 'Shellvars.lns',
  }

  # default repose valve sysconfig options
  $repose_sysconfig = [
    "set RUN_PORT '${run_port}'",
    "set SHUTDOWN_PORT '${shutdown_port}'",
    "set DAEMON_HOME '${daemon_home}'",
    "set LOG_PATH '${log_path}'",
    "set PID_FILE '${pid_file}'",
    "set USER '${user}'",
    "set daemonize '${daemonize}'",
    "set daemonize_opts '\"${daemonize_opts}\"'",
    "set run_opts '\"${run_opts}\"'",
    "set java_opts '\"\${java_opts} ${java_options}\"'",
  ]

  # if saxon_home provided for saxon license
  if $saxon_home {
    $saxon_sysconfig = [ 
      "set SAXON_HOME '${saxon_home}'",
      "set SAXON_HOME/export ''"
    ]
  } else {
    $saxon_sysconfig = 'rm SAXON_HOME'
  }

  # run augeas with our changes
  augeas {
    'repose_sysconfig':
      context => '/files/etc/sysconfig/repose',
      changes => [ $repose_sysconfig, $saxon_sysconfig ]
  }
}
