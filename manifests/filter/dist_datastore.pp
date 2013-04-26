# [*nodes*]
# Array of nodes participating in the distributed datastore
#
# [*allow_all*]
# Bool. Whether or not to just allow 
#

class repose::filter::dist_datastore (
  $ensure    = present,
  $nodes,
  $allow_all = false,
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

  file { "${repose::params::configdir}/dist-datastore.cfg.xml":
    ensure  => file,
    content => template('repose/dist-datastore.cfg.xml.erb')
  }

}
