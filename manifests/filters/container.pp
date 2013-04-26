# [*app_name*]
#
# [*log_dir*]
#
# [*log_level*]
#

class repose::filter::container (
  $ensure    = present,
  $app_name,
  $log_dir   = $repose::params::logdir,
  $log_level = 'WARN',
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

## Manage actions

  File {
    owner => $repose::params::user,
    group => $repose::params::group,
    mode  => $repose::params::mode,
    require => Package['repose-filters'],
  }

  file { "${repose::params::configdir}/log4j.properties":
    ensure  => file,
    content => template('repose/log4j.properties.erb')
  }

  file { "${repose::params::configdir}/container.cfg.xml":
    ensure  => file,
    content => template('repose/container.cfg.xml.erb')
  }

}
