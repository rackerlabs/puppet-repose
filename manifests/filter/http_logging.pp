# [*log_files*]
# List of Hashes containing id, format, and location
#
class repose::filter::http_logging (
  $ensure = present,
  $log_files = undef,
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

## log_files
  if $log_files == undef {
    fail('log_files is a required parameter. see documentation for details.')
  }

## Manage actions

  file { "${repose::params::configdir}/http-logging.cfg.xml":
    ensure  => file,
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Package['repose-filters'],
    content => template('repose/http-logging.cfg.xml.erb'),
  }

}
