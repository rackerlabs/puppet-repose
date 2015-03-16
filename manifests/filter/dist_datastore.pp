# == Resource: repose::filter::dist_datastore
#
# This is a resource for generating distributed
# datastore configuration files
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure config file is present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String. Config filename
# Defaults to <tt>dist-datastore.cfg.xml</tt>
#
# [*nodes*]
# Array of nodes participating in the distributed datastore
# Defaults to <tt>undef</tt>
#
# [*port_config*]
# Array for port-config items, should have a hash items for port and cluster.
# node hash item is optional.
# Defaults to <tt>undef</tt>
#
# [*allow_all*]
# Bool. Whether or not to just allow anyone to just access the datastore
# Defaults to <tt>false</tt>
#
# === Links
#
# * http://wiki.openrepose.org/display/REPOSE/Datastore#Datastore-distributed
#
# === Examples
# repose::filter::dist_datastore {
#   'default':
#     nodes => [ 'test1.domain', 'test2.domain' ],
#     port_config => [
#       {
#         port => 9191,
#         cluster => "repose",
#       },
#     ]
# }
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::dist_datastore (
  $ensure      = present,
  $filename    = 'dist-datastore.cfg.xml',
  $nodes       = undef,
  $port_config = undef,
  $allow_all   = false,
) {

### Validate parameters

## ensure
  if ! ($ensure in [ present, absent ]) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
  } else {
    $file_ensure = $ensure ? {
      present => file,
      absent  => absent,
    }
  }
  if $::debug {
    debug("\$ensure = '${ensure}'")
  }

## nodes only required if ensure is present
  if $ensure == present {
    if $nodes == undef {
      fail('nodes is a required parameter')
    }
    $content_template = template("${module_name}/dist-datastore.cfg.xml.erb")
  } else {
    # ensure is absent so no need to us a template
    $content_template = undef
  }


## Manage actions

  file { "${repose::params::configdir}/${filename}":
    ensure  => $file_ensure,
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Class['::repose::package'],
    content => $content_template
  }

}
