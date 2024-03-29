# == Class: repose::service
#
# This class exists to define the services and any related
# actions, functionality and logical units in a central place.
#
#
# === Parameters
#
# [*ensure*]
#  String. If this is set to absent, then the service is stopped.  
#  Defaults to <tt>present</tt>
#
# [*content*]
#  String. The contents of the systemd dropin file. Leave undef if no
#  dropin file is required. When used, this will most likely be a multi-line string.
#  Defaults to <tt>undef</tt>
#
# [*service_hasstatus*]
#  Boolean. If true, service has a 'status' command.  
#  Defaults to <tt>true</tt> in common.yaml
#
# [*service_hasrestart*]
#  Boolean. If true, service has a 'restart' command.  
#  Defaults to <tt>true</tt> in common.yaml
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
) {
### Logic

## set params: off
  if $repose::ensure == 'absent' {
    $_ensure = 'stopped'
## set params: in operation
  } else {
    $_ensure = 'running'
  }

  # Here we have the opportunity to specify a systemd dropin for repose
  if $repose::content {
    systemd::dropin_file { 'repose-local.conf':
      unit    => 'repose.service',
      content => $repose::content,
    }
  }

### Manage actions
  service { $repose::service_name:
    ensure     => $_ensure,
    enable     => $repose::enable,
    hasstatus  => $repose::service_hasstatus,
    hasrestart => $repose::service_hasrestart,
  }
}
