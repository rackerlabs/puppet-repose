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
# [*content*]
#  String. The contents of the systemd dropin file. Leave undef if no
#  dropin file is required. When used, this will most likely be a multi-line string.
#  Defaults to <tt>undef</tt>
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
  Boolean                                     $service_hasstatus,
  Boolean                                     $service_hasrestart,
  Optional[Variant[String,Sensitive[String]]] $content = undef,
  String                                      $ensure  = $repose::ensure,
  Variant[Boolean,String]                     $enable  = $repose::enable,
) {

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

  # Here we have the opportunity to specify a systemd dropin for repose
  if $content {
    systemd::dropin_file {'repose-local.conf':
      unit    => 'repose.service',
      content => $content,
    }
  }

### Manage actions
  service { $repose::service_name:
    ensure     => $service_ensure,
    enable     => $enable,
    hasstatus  => $service_hasstatus,
    hasrestart => $service_hasrestart,
  }
}
