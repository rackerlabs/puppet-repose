# [*app_name*]
#
# [*validators*]
# List containing list of validator options
#
# [*validators::validator*]
# List containing role, applications and resources
#
# [*multi_role_match*]
# boolean string
#
class repose::filter::api_validator (
  $ensure     = present,
  $app_name   = 'repose',
  $validators= undef,
  $multi_role_match = 'false',
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

## validators
  if $validators == undef {
    fail('validators is a required list')
  }


## Manage actions

  file { "${repose::params::configdir}/api-validator.cfg.xml":
    ensure  => file,
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Package['repose-filters'],
    content => template('repose/api-validator.cfg.xml.erb'),
  }

}
