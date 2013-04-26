class repose::tomcat7 (
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
