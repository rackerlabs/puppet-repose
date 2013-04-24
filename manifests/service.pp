# == Class: MODULE::service
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
#   class { 'MODULE::service': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# [ NO empty lines allowed between this and definition below for rdoc ]
class MODULE::service {

### Logic

## set params: in operation
  if $MODULE::ensure == present {
    $service_ensure = $MODULE::enable ? {
      true  => running,
      false => stopped,
    }

## set params: off
  } else {
    $service_ensure = stopped
  }

### Manage actions

  service { $MODULE::params::service:
    ensure     => $service_ensure,
    enable     => $MODULE::enable,
    hasstatus  => $MODULE::params::service_hasrestart,
    hasrestart => $MODULE::params::service_hasrestart,
    require    => Package[$MODULE::params::package],
    subscribe  => File[$MODULE::params::configfile]
  }

}
