# [*app_name*]
#
# [*target_uri*]
# String. The URI of the API repose is proxying
#
class repose::filter::versioning (
  $ensure     = present,
  $app_name   = 'repose',
  $target_uri = undef,
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

## target_uri
  if $target_uri == undef {
    fail('target_uri is a required parameter')
  }

## Manage actions

  file { "${repose::params::configdir}/versioning.cfg.xml":
    ensure  => file,
    owner   => $repose::params::user,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Package['repose-filters'],
    source  => 'puppet:///modules/repose/versioning.cfg.xml'
  }

}
