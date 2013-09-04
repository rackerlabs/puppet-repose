# [*app_name*]
#
# [*header_filters*]
# List of filters by name, which conains a list of headers
#
# [*media_types*]
# List of media_types, each containing name, variant-extension, preferred
#
class repose::filter::content_normalization (
  $ensure     = present,
  $app_name   = 'repose',
  $content_normalization = undef,
  $header_filters =  undef,
  $media_types = undef,
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

  file { "${repose::params::configdir}/content_normalization.cfg.xml":
    ensure  => file,
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Package['repose-filters'],
    content => template('repose/content_normalization.cfg.xml.erb'),
  }

}
