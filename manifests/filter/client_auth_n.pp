# == Resource: repose::filter::client_auth_n
#
# This is a resource for generating client-auth-n configuration files
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure config file is present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String. Filename to output config
# Defaults to <tt>client-auth-n.cfg.xml</tt>
#
# [*auth*]
# Required. Hash containing user, pass, and uri
#
# [*client_maps*]
# Array contianing client mapping regexes for tenanted mode.
#
# [*white_lists*]
# Array contianing uri regexes to white list
#
# [*delegable*]
# Bool.
# Defaults to <tt>false</tt>
#
# [*tendanted*]
# Bool.
# Defaults to <tt>false</tt>
#
# [*group_cache_timeout*]
# Integer as String.
# Defaults to <tt>60000</tt>
#
# === Links
#
# * http://wiki.openrepose.org/display/REPOSE/Client+Authentication+Filter
#
# === Examples
#
# repose::filter::client_auth_n {
#   'default':
#     auth => {
#       user => 'test',
#       pass => 'testpass',
#       uri => 'testuri',
#     },
#     client_maps => [ '.*/events/(\d+)', ],
# }
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::client_auth_n (
  $ensure              = present,
  $filename            = 'client-auth-n.cfg.xml',
  $auth                = undef,
  $client_maps         = undef,
  $white_lists         = undef,
  $delegable           = false,
  $tenanted            = false,
  $group_cache_timeout = '60000',
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

## auth
  if $auth == undef {
    fail('auth is a required parameter')
  }

## Manage actions

  file { "${repose::params::configdir}/${filename}":
    ensure  => $file_ensure,
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Package['repose-filters'],
    content => template('repose/client-auth-n.cfg.xml.erb')
  }

}
