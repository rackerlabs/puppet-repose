# [*app_name*]
#
# [*header_translations*]
# List containing original_name, new_name, remove_original
#
class repose::filter::header_translation (
  $ensure     = present,
  $app_name   = 'repose',
  $header_translations = undef,
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

  file { "${repose::params::configdir}/header_tranlation.cfg.xml":
    ensure  => file,
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Package['repose-filters'],
    content => template('repose/header_translation.cfg.xml.erb'),
  }

}
