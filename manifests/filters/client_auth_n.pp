# [*auth*]
# Required. Hash containing user, pass, and uri
#
# [*client_maps*]
# Required. Array contianing client mapping regexes
# 
# [*white_lists*]
# Array contianing uri regexes to white list
# 
# [*delegable*]
# Bool.
# Defaults to <tt>false</tt>
#
# [*tendanted*]
# Bool.
# Defaults to <tt>false</tt>
#
# [*group_cache_timeout*]
# Integer as String.
# Defaults to <tt>60000</tt>

class repose::filter::client_auth_n (
  $auth,
  $client_map,
  $ensure              = present,
  $white_lists         = {},
  $delegable           = false,
  $tenanted            = false,
  $group_cache_timeout = '60000',
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

  file { "${repose::params::configdir}/client-auth-n.cfg.xml":
    ensure  => file,
    owner   => $repose::params::user,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Package['repose-filters'],
    content => template('repose/client-auth-n.cfg.xml.erb')
  }

}
