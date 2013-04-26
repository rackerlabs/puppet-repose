class repose::filter::rate_limiting (
  $ensure     = present,
  $datastore,
  $delegation = false,
  $request_endpoints,
  $limit_groups,
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

  file { "${repose::params::configdir}/etc/repose/rate-limiting.cfg.xml":
    ensure  => file,
    owner   => $repose::params::user,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Package['repose-filters'],
    content => template('repose/rate-limiting.cfg.xml.erb')
  }

}
