class repose::valve (
  $ensure      = $repose::params::ensure,
  $enable      = $repose::params::enable,
  $autoupgrade = $repose::params::autoupgrade,
) inherits repose::params {

  class { 'repose':
    ensure      => $ensure,
    enable      => $enable,
    autoupgrade => $autoupgrade,
    container   => 'tomcat7',
  }

}
