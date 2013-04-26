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
# [ NO empty lines allowed between this and definition below for rdoc ]
class repose::params inherits repose::config {

### Variables that are intended to be over ridden using repose::config
### Validation of these values is recommended to occur in primary class

## content - name of the template that will provide primary client config
## Default to the module's included client template
  if empty($repose::config::content) {
    $content = 'config.erb'
  } else {
    $content = $repose::config::content
    if $::debug { debug('$content overridden by local config') }
  }

### Default values for the parameters of the main module class, init.pp

## ensure
  $ensure = present

## enable
  $enable = true

## autoupgrade
  $autoupgrade = false

## container
  $container = 'valve'

## container_options
  $container_options = ['valve','tomcat']

### Package specific in

## service
  $service = $::osfamily ? {
    /(RedHat|Debian)/ => [ 'repose-valve' ],
  }

## service capabilities
  $service_hasstatus = $::osfamily ? {
    /(RedHat|Debian)/ => true,
  }

  $service_hasrestart = $::osfamily ? {
    /(RedHat|Debian)/ => true,
  }

## tomcat_packages
  $tomcat_package = $::osfamily ? {
    /(RedHat|Debian)/ => [ 'repose-war','repose-filters','repose-extension-filters' ],
  }

## valve_packages
  $valve_package = $::osfamily ? {
    /(RedHat|Debian)/ => [ 'repose-valve','repose-filters','repose-extension-filters' ],
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
    /(RedHat|Debian)/ => '0440',
  }

## dirmode
  $dirmode = $::osfamily ? {
    /(RedHat|Debian)/ => '0750',
  }

## sourcedir
  $sourcedir = "puppet:///modules/${module_name}"

}
