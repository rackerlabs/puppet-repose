# == Class: repose::package
#
# This class exists to coordinate all software package management related
# actions, functionality and logical units in a central place.
#
#
# === Parameters
#
# [*container*]
# The package list to use based on the container that is used to run
# repose in this environment
#
# === Examples
#
# Primarily to be used by the repose base class, but you can use:
#   class { 'repose::package': contaienr => 'valve' }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# [ NO empty lines allowed between this and definition below for rdoc ]
class repose::package ($container) {

### Logic

## set params: in operation
  if $repose::ensure == present {
    $package_ensure = $repose::autoupgrade ? {
      true  => latest,
      false => present,
    }

## set params: removal
  } else {
    $package_ensure = purged
  }

## Pick packages
  $packages = $container ? {
    'tomcat7' => $repose::params::tomcat7_packages,
    'valve'   => $repose::params::tomcat7_packages,
  }

### Manage actions

  package { $packages:
    ensure => $package_ensure,
  }

}
