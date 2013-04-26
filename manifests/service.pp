# == Class: repose::service
#
# This class exists to define the services and any related
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
#   class { 'repose::service': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# [ NO empty lines allowed between this and definition below for rdoc ]
class repose::service (
  $ensure = $repose::params::ensure,
  $enable = $repose::params::enable,
) inherits repose::params {

### Logic

## set params: in operation
  if $ensure == present {
    $service_ensure = $enable ? {
      true  => running,
      false => stopped,
    }

## set params: off
  } else {
    $service_ensure = stopped
  }

### Manage actions

  service { $repose::params::service:
    ensure     => $service_ensure,
    enable     => $enable,
    hasstatus  => $repose::params::service_hasrestart,
    hasrestart => $repose::params::service_hasrestart,
  }

}
