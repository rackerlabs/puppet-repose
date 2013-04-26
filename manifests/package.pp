# == Class: repose::package
#
# This class exists to coordinate all software package management related
# actions, functionality and logical units in a central place.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'repose::package': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# [ NO empty lines allowed between this and definition below for rdoc ]
class repose::package {

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

### Manage actions

  package { $repose::params::package:
    ensure => $package_ensure,
  }

}
