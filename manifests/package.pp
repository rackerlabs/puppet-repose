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
# === Authors
#
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
class repose::package (
  $ensure      = $repose::params::ensure,
  $autoupgrade = $repose::params::autoupgrade,
  $container   = $repose::params::container,
) inherits repose::params {

### Logic

## set params: in operation
  if $ensure == present {
    $package_ensure = $autoupgrade ? {
      true  => latest,
      false => present,
    }

## set params: removal
  } else {
    $package_ensure = purged
  }

## Pick packages
  $container_package = $container ? {
    'tomcat7' => $repose::params::tomcat7_package,
    'valve'   => $repose::params::valve_package,
  }

## Handle adding a dependency of service for valve
  if $container == 'valve' {
    $before = Service[$repose::params::service]
  } else {
    $before = undef
  }


### Manage actions

  package { $container_package:
    ensure => $package_ensure,
    before => $before,
  }

  package { $repose::params::packages:
    ensure  => $package_ensure,
    require => Package[$container_package],
  }

}
