class repose::filter::validator (
  $ensure   = present,
  $app_name = 'repose',
  $target_uri,
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

  file { "${repose::params::configdir}/validator.cfg.xml":
    ensure  => file,
    owner => $repose::params::user,
    group => $repose::params::group,
    mode  => $repose::params::mode,
    require => Package['repose-filters'],
    source  => 'puppet:///modules/repose/validator.cfg.xml'
  }

}
