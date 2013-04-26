class repose::valve (
  $ensure      = $repose::params::ensure,
  $enable      = $repose::params::enable,
  $autoupgrade = $repose::params::autoupgrade,
) inherits repose::params {

  class { 'repose':
    ensure      => $ensure,
    enable      => $enable,
    autoupgrade => $autoupgrade,
    container   => 'valve',
  }

  file { '/etc/sysconfig/repose':
    ensure  => file,
    owner   => root,
    group   => root,
    source  => 'puppet:///modules/repose/valve-sysconfig',
    require => [ Class['newrelic'], Package[$repose::params::valve_package] ],
    notify  => Service[$repose::params::service],
  }

}
