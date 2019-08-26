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
# [*rh_old_packages*]
# Boolean. At version 6.2 repose renamed several of their packages to
# standardize between deb/rpm.  This variable exposes access to the old
# naming on rpm distros. It defaults to <tt>true</tt> for the time being
# to not break existing users.
# TODO: Determine a time to default to false. Then when to drop support.
#
# [*cfg_new_namespace*]
# Boolean. Repose 7 introducted new namespaces for the configuration files.
# This flag is used to indicate the use of the new docs.openrepose.org
# namespace instead of the docs.rackspacecloud.com namespace. The old namespace
# url should work but there have been some issues. If running repose >= 7,
# set this to true.
# TODO: Determine a time to default to false. Then when to drop support.
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
  $ensure               = $repose::params::ensure,
  $enable               = $repose::params::enable,
  $container            = $repose::params::container,
  $autoupgrade          = $repose::params::autoupgrade,
  $rh_old_packages      = $repose::params::rh_old_packages,
  $cfg_new_namespace    = $repose::params::cfg_new_namespace,
  $experimental_filters = $repose::params::experimental_filters,
  $identity_filters     = $repose::params::identity_filters,
) inherits repose::params {

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
    if $ensure != $repose::params::ensure {
      debug('$ensure overridden by class parameter')
    }
    debug("\$ensure = '${ensure}'")
  }

## enable - we don't validate because all standard options are acceptable
  if $::debug {
    if $enable != $repose::params::enable {
      debug('$enable overridden by class parameter')
    }
    debug("\$enable = '${enable}'")
  }

## autoupgrade
  validate_bool($autoupgrade)
  if $::debug {
    if $autoupgrade != $repose::params::autoupgrade {
      debug('$autoupgrade overridden by class parameter')
    }
    debug("\$autoupgrade = '${autoupgrade}'")
  }

## container
  if ! ($container in $repose::params::container_options) {
    fail("\"${container}\" is not a valid container parameter value")
  }
  if $::debug {
    if $container != $repose::params::container {
      debug('$container overridden by class parameter')
    }
    debug("\$container = '${container}'")
  }

## figure out cfg namespace host
  if $cfg_new_namespace {
    $cfg_namespace_host = 'docs.openrepose.org'
    # these are needed for historical differences in namespace hosts
    $cfg_namespace_host_header = 'docs.openrepose.org'
    $cfg_namespace_host_validator = 'docs.openrepose.org'
    $cfg_namespace_host_ip = 'docs.openrepose.org'
    $cfg_namespace_host_compression = 'docs.openrepose.org'
    $cfg_namespace_host_dist = 'docs.openrepose.org'
    $cfg_namespace_host_destination_router = 'docs.openrepose.org'
    $cfg_namespace_host_uri_stripper = 'docs.openrepose.org'
  } else {
    $cfg_namespace_host = 'docs.rackspacecloud.com'
    # these are needed for historical differences in namespace hosts
    $cfg_namespace_host_header = 'docs.api.rackspacecloud.com'
    $cfg_namespace_host_validator = 'openrepose.org'
    $cfg_namespace_host_ip = 'docs.api.rackspacecloud.com'
    $cfg_namespace_host_compression = 'docs.api.rackspacecloud.com'
    $cfg_namespace_host_dist = 'openrepose.org'
    $cfg_namespace_host_destination_router = 'openrepose.org'
    $cfg_namespace_host_uri_stripper = 'docs.api.rackspacecloud.com'
  }

### Manage actions

## package(s)
  class { 'repose::package':
    ensure               => $ensure,
    autoupgrade          => $autoupgrade,
    container            => $container,
    rh_old_packages      => $rh_old_packages,
    experimental_filters => $experimental_filters,
    identity_filters     => $identity_filters,
  }

## service
  if ( $container in [ 'valve', 'repose9' ]) {
    class { 'repose::service':
      ensure    => $ensure,
      enable    => $enable,
      container => $container,
    }
  }

## files/directories
  File {
    mode    => $repose::params::dirmode,
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    require => Package[$repose::package::container_package],
  }

  file { $repose::params::configdir:
    ensure => $dir_ensure,
  }

  file { '/etc/security/limits.d/repose':
    ensure => $file_ensure,
    source => 'puppet:///modules/repose/limits',
  }

}
