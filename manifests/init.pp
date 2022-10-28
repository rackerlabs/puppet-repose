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
# [*cfg_namespace_host*]
# String. XML namespace reference.
#
# [*service_name*]
# String. Name of Repose service.
#
# [*packages*]
# Array. List of supplementary packages to be installed.
#
# [*package_name*]
# String. Name of primary repose package.
#
# [*configdir*]
# String. Directory repose configs should live in.
#
# [*group*]
# String. Group that repose user belongs in.
# 
# [*owner*]
# String. Name of repose user.
# 
# [*filter*]
# Hash.
# 
# [*mode*]
# Stdlib::Filemode. File permissions.
#
# [*dirmode*]
# Stdlib::Filemode. Directory permissions.
# 
# [*port*]
# Integer. Port repose listens on.
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
  String $ensure,
  Boolean $enable,
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
  Boolean $experimental_filters,
  Array $experimental_filters_packages,
  Boolean $identity_filters,
  Array $identity_filters_packages,
  String $daemon_home,
  String $log_path,
  String $user,
  String $daemonize,
  String $daemonize_opts,
  Boolean $service_hasstatus,
  Boolean $service_hasrestart,
  Optional[String] $java_options = undef,
  Optional[String] $saxon_home   = undef,
  Array $log_files         = ['/var/log/repose/repose.log'],
  String $rotate_frequency = 'daily',
  Integer $rotate_count    = 4,
  Boolean $compress        = true,
  Boolean $delay_compress  = true,
  Boolean $use_date_ext    = true,
  Optional[Variant[String,Sensitive[String]]] $content = undef,
) {
  contain repose::package
  contain repose::config
  contain repose::filter
  contain repose::service

  Class['repose::package']
  -> Class['repose::config']
  ~> Class['repose::filter']
  ~> Class['repose::service']
}
