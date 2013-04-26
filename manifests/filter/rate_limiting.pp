# [*datastore*]
# String. Which distributed datastore to use for storing maintaining
# the rate limit information.
#
# [*delegation*]
# Boolean.  Dunno
#
# [*request_endpoint*]
# Required Hash.  Contains String(uri-regex) and Boolean(include-absolute-limits)
#
# [*limit_groups*]
# Required Array of hashes.  Hashes should contain
#   String(id), String(groups), Boolean(default), and ArrayofHashes(limits)
# Where the hashes in limits should contain the Strings:
#   uri, uri-regex, http-methods, unit, value
#
class repose::filter::rate_limiting (
  $ensure           = present,
  $datastore        = undef,
  $delegation       = false,
  $request_endpoint = undef ,
  $limit_groups     = undef,
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

## request_endpoint
  if $request_endpoint == undef {
    fail('request_endpoint is a required parameter. see documentation for details.')
  }

## limit_groups
  if $limit_groups == undef {
    fail('limit_groups is a required parameter. see documentation for details.')
  }

## Manage actions

  file { "${repose::params::configdir}/rate-limiting.cfg.xml":
    ensure  => file,
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Package['repose-filters'],
    content => template('repose/rate-limiting.cfg.xml.erb')
  }

}
