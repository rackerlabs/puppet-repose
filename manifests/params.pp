# == Class: repose::params
#
# This class exists to
# 1. Declutter the default value assignment for class parameters.
# 2. Manage internally used module variables in a central place.
#
# Therefore, many operating system dependent differences (names, paths, ...)
# are addressed in here.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class is not intended to be used directly.
#
#
# === Links
#
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
class repose::params {

## ensure
  $ensure = present

## enable
  $enable = true

## autoupgrade
  $autoupgrade = false

## container
  $container = 'valve'

## container_options
  $container_options = ['valve','tomcat7']

### Package specific in

## service
  $service = $::osfamily ? {
    /(RedHat|Debian)/ => 'repose-valve',
  }

## service capabilities
  $service_hasstatus = $::osfamily ? {
    /(RedHat|Debian)/ => true,
  }

  $service_hasrestart = $::osfamily ? {
    /(RedHat|Debian)/ => true,
  }

## packages
  $packages = $::osfamily ? {
    /(RedHat|Debian)/ => [ 'repose-filters','repose-extension-filters' ],
  }

## tomcat7_package
  $tomcat7_package = $::osfamily ? {
    /(RedHat|Debian)/ => 'repose-war',
  }

## valve_package
  $valve_package = $::osfamily ? {
    /(RedHat|Debian)/ => 'repose-valve',
  }

## configdir
  $configdir = $::osfamily ? {
    /(RedHat|Debian)/ => '/etc/repose',
  }

## logdir
  $logdir = $::osfamily ? {
    /(RedHat|Debian)/ => '/var/log/repose',
  }

## owner
  $owner = $::osfamily ? {
    /(RedHat|Debian)/ => repose,
  }

## group
  $group = $::osfamily ? {
    /(RedHat|Debian)/ => repose,
  }

## mode
  $mode = $::osfamily ? {
    /(RedHat|Debian)/ => '0660',
  }

## dirmode
  $dirmode = $::osfamily ? {
    /(RedHat|Debian)/ => '0750',
  }

## port
  $port = '8080'

## run_port for valve
  $run_port = '9090'

## shutdown port for valve
  $shutdown_port = '8188'

## sourcedir
  $sourcedir = "puppet:///modules/${module_name}"

## daemon_home for valve
  $daemon_home = '/usr/share/lib/repose'

## pid file for valve
  $pid_file = '/var/run/repose-valve.pid'

## user for valve
  $user = 'repose'

## daemonize bin for repose-valve
  $daemonize = '/usr/sbin/daemonize'

## daemonize opts for repose-valve
  $daemonize_opts = '-c $DAEMON_HOME -p $PID_FILE -u $USER -o $LOG_PATH/stdout.log -e $LOG_PATH/stderr.log -l /var/lock/subsys/$NAME'

## run ops for repose-valve
  $run_opts = '-s $SHUTDOWN_PORT -p $RUN_PORT -c $CONFIG_DIRECTORY'
}
