# == Class: repose
#
# This class is able to install or remove repose on a node.
#
#
# === Parameters
#
# The default values for the parameters are set in repose::params. Have
# a look at the corresponding <tt>params.pp</tt> manifest file if you need more
# technical information about them.
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
# === Examples
#
# * Installation:
#
# class { 'repose': }
#
# * Removal/decommissioning:
#
# class { 'repose': ensure => 'absent' }
#
#
# === Authors
#
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
class repose (
  Enum['absent','present'] $ensure,
  Boolean $autoupgrade,
  String $cfg_namespace_host,
  String $service_name,
  Array $packages,
  String $package_name,
  String $configdir,
  String $owner,
  String $group,
  Hash $filter,
  Stdlib::Filemode $mode,
  Stdlib::Filemode $dirmode,
  Integer $port,
) {

### Validate parameters

## ensure
  if ! ($ensure) {
    fail("\"${ensure}\" is required. It should be present or absent")
  } else {
    $file_ensure = $ensure ? {
      absent  => absent,
      default => file,
    }
    $dir_ensure = $ensure ? {
      absent  => absent,
      default => directory,
    }
  }
  if $::debug {
    if $ensure != $repose::ensure {
      debug('$ensure overridden by class parameter')
    }
    debug("\$ensure = '${ensure}'")
  }

## autoupgrade
  if $::debug {
    if $autoupgrade != $repose::autoupgrade {
      debug('$autoupgrade overridden by class parameter')
    }
    debug("\$autoupgrade = '${autoupgrade}'")
  }

### Manage actions

  contain repose::package
  contain repose::config
  contain repose::filter
  contain repose::service
  contain repose::filter

  Class['repose::package']
  -> Class['repose::config']
  ~> Class['repose::filter']
  ~> Class['repose::service']

}
