# == Class: repose::service
#
# This class exists to define the services and any related
# actions, functionality and logical units in a central place.
#
#
# === Parameters
#
# [*ensure*]
#  String. If this is set to absent, then the service is stopped.  Otherwise
#  if this is set, it will be set to running unless enable is set to false.
#  Defaults to <tt>present</tt>
#
# [*enable*]
#  Boolean/String. This toggles if the service should be stopped, running or
#  manual.
#  Defaults to <tt>true</tt>
#
# [*container*]
#  String. This sets the container type, used in this manifest to determine
#  the service name to use. 
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'repose::service': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
# === Authors
#
# * Josh Bell <mailto: josh.bell@rackspace.com>
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
class repose::service (
  $ensure    = $repose::params::ensure,
  $enable    = $repose::params::enable,
  $container = $repose::params::container,
) inherits repose::params {

### Logic

## set params: off
  if $ensure == absent {
    $service_ensure = stopped
## set params: in operation
  } else {
    $service_ensure = $enable ? {
      false   => stopped,
      true    => running,
      default => manual
    }
  }

### Manage actions

  if $container == 'valve' {
    service { $repose::params::service:
      ensure     => $service_ensure,
      enable     => $enable,
      hasstatus  => $repose::params::service_hasstatus,
      hasrestart => $repose::params::service_hasrestart,
    }
 } elsif $container == 'repose9' {
    service { $repose::params::repose9_service:
      ensure     => $service_ensure,
      enable     => $enable,
      hasstatus  => $repose::params::service_hasstatus,
      hasrestart => $repose::params::service_hasrestart,
    }
 }

}
