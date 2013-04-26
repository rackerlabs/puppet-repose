# [*app_name*]
#
# [*nodes*]
#
# [*filters*]
#
# [*endpoints*]
#
# [*port*]
#
class repose::filter::system_model (
  $ensure    = present,
  $app_name  = undef,
  $nodes     = undef,
  $filters   = undef,
  $endpoints = undef,
  $port      = $repose::params::port,
) inherits repose::params {

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

## app_name
  if $app_name == undef {
    fail('app_name is a required parameter')
  }

## nodes
  if $nodes == undef {
    fail('nodes is a required parameter')
  }

## filters
  if $filters == undef {
    fail('filters is a required parameter. see documentation for details.')
  }

## endpoints
  if $endpoints == undef {
    fail('endpoints is a required parameter. see documentation for details.')
  }

## Manage actions

  file { "${repose::params::configdir}/etc/repose/system-model.cfg.xml":
    ensure  => file,
    owner   => $repose::params::user,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Package['repose-filters'],
    content => template('repose/system-model.cfg.xml.erb')
  }

}
