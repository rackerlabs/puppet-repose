# [*nodes*]
# Array of nodes participating in the distributed datastore
#
# [*allow_all*]
# Bool. Whether or not to just allow anyone to just access the datastore
#

class repose::filter::dist_datastore (
  $ensure    = present,
  $nodes     = undef,
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

## nodes
  if $nodes == undef {
    fail('nodes is a required parameter')
  }


## Manage actions

  file { "${repose::params::configdir}/dist-datastore.cfg.xml":
    ensure  => file,
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Package['repose-filters'],
    content => template('repose/dist-datastore.cfg.xml.erb')
  }

}
