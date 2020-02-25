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
# [*enable*]
# Bool/String. Controls if the managed service shall be running(<tt>true</tt>),
# stopped(<tt>false</tt>), or <tt>manual</tt>. This affects the service state
# at both boot and during runtime.  If set to <tt>manual</tt> Puppet will
# ignore the state of the service.
# Defaults to <tt>true</tt>.
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
  Enum['present','absent'] $ensure,
  Boolean $enable,
  Enum['repose9'] $container,
  String $configdir,
  Boolean $autoupgrade,
  Boolean $experimental_filters,
  Boolean $identity_filters,
  Array $container_options,
  String $repose9_package,
  String $repose9_service,
  Array $packages,
  Array $experimental_filters_packages,
  String $dirmode,
  String $owner,
  String $group,
) {

### Validate parameters

## ensure
  if ! ($ensure) {
    fail("\"${ensure}\" is required. It should be present, absent, latest or a version")
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

## enable - we don't validate because all standard options are acceptable
  if $::debug {
    if $enable != $repose::enable {
      debug('$enable overridden by class parameter')
    }
    debug("\$enable = '${enable}'")
  }

## autoupgrade
  if $::debug {
    if $autoupgrade != $repose::autoupgrade {
      debug('$autoupgrade overridden by class parameter')
    }
    debug("\$autoupgrade = '${autoupgrade}'")
  }

## container
  if ! ($container in $repose::container_options) {
    fail("\"${container}\" is not a valid container parameter value")
  }
  if $::debug {
    if $container != $repose::container {
      debug('$container overridden by class parameter')
    }
    debug("\$container = '${container}'")
  }

### Manage actions

## package(s)
  class { 'repose::package':
    ensure               => $ensure,
    autoupgrade          => $autoupgrade,
    container            => $container,
    experimental_filters => $experimental_filters,
    identity_filters     => $identity_filters,
  }

## service
  class { 'repose::service':
    ensure    => $ensure,
    enable    => $enable,
    container => $container,
  }

## files/directories
  File {
    mode    => $dirmode,
    owner   => $owner,
    group   => $group,
    require => Package[$repose::package::container_package],
  }

  file { $repose::configdir:
    ensure => $dir_ensure,
  }

  file { '/etc/security/limits.d/repose':
    ensure => $file_ensure,
    source => 'puppet:///modules/repose/limits',
  }

}
