# == Class: repose::tomcat7
#
# This class is able to install or remove repose
# for tomcat7 on a node.
#
# === Parameters
#
# The default values for the parameters are set in repose::params. Have
# a look at the corresponding <tt>params.pp</tt> manifest file if you need more
# technical information about them.
#
# [*ensure*]
# String. Controls if the managed resources shall be <tt>present</tt> or
# <tt>absent</tt>. If set to <tt>absent</tt>:
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
#
# === Examples
#
# * Installation:
#
# class { 'repose::tomcat7': }
#
# * Removal/decommissioning:
#
# class { 'repose::tomcat7': ensure => 'absent' }
#
#
# === Authors
#
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
class repose::tomcat7 (
  $ensure           = $repose::params::ensure,
  $enable           = $repose::params::enable,
  $autoupgrade      = $repose::params::autoupgrade,
  $rh_old_packages  = $repose::params::rh_old_packages,
) inherits repose::params {

  class { 'repose':
    ensure          => $ensure,
    enable          => $enable,
    autoupgrade     => $autoupgrade,
    rh_old_packages => $rh_old_packages,
    container       => 'tomcat7',
  }

}
