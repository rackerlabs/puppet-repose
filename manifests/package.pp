# == Class: repose::package
#
# This class exists to coordinate all software package management related
# actions, functionality and logical units in a central place.
#
#
# === Parameters
#
# [*ensure*]
# String. Controls if the managed resources shall be <tt>present</tt>,
# <tt>absent</tt>, <tt>latest</tt> or a version nuymber. If set to
# <tt>absent</tt>:
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
# [*autoupgrade*]
# Boolean. If set to <tt>true</tt>, any managed package gets upgraded
# on each Puppet run when the package provider is able to find a newer
# version than the present one. The exact behavior is provider dependent.
# Q.v.:
# * Puppet type reference: {package, "upgradeable"}[http://j.mp/xbxmNP]
# * {Puppet's package provider source code}[http://j.mp/wtVCaL]
# Defaults to <tt>false</tt>.
#
# [*container*]
# The package list to use based on the container that is used to run
# repose in this environment
#
# [*experimental_filters*]
# Boolean. Install the experimental filters bundle package
# Defaults to <tt>false</tt>
#
# [*identity_filters*]
# Boolean. Install the identity filters bundle package
# Defaults to <tt>false</tt>
#
# === Examples
#
# Primarily to be used by the repose base class, but you can use:
#   class { 'repose::package': container => 'valve' }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
# === Authors
#
# * Josh Bell <mailto:josh.bell@rackspace.com>
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
# * c/o Cloud Identity Ops <mailto:identityops@rackspace.com>
#
class repose::package (
  Boolean $experimental_filters,
  Array $experimental_filters_packages,
  Boolean $identity_filters,
  Array $identity_filters_packages,
  String $ensure       = $repose::ensure,
  Boolean $autoupgrade = $repose::autoupgrade,
) {

### Logic

## set params: removal
  if $ensure == absent {
    $package_ensure = purged
## set params: in operation
  } else {
    if $autoupgrade == true {
      $package_ensure = latest
    } else {
      $package_ensure = $ensure
    }
  }

### Manage actions
  package { $repose::package_name:
    ensure => $package_ensure,
  }

  package { $repose::packages:
    ensure  => $package_ensure,
    require => Package[$repose::package_name],
  }

  if $experimental_filters == true {
    package { $experimental_filters_packages:
      ensure  => $package_ensure,
      require => Package[$repose::package_name],
    }
  } else {
    package { $experimental_filters_packages:
      ensure  => absent,
      require => Package[$repose::package_name],
    }
  }

  if $identity_filters == true {
    package { $identity_filters_packages:
      ensure  => $package_ensure,
      require => Package[$repose::package_name],
    }
  }
}
