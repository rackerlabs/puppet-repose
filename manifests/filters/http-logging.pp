class repose::valve (
  $nodes,
  $filters,
  $endpoints,
  $auth,
  $port             = $repose::params::port,
  $usage_schema_dir = $repose::params::usage_schema_dir,
) inherits repose::params {

  File {
    owner => $repose::params::user,
    group => $repose::params::group,
    mode  => $repose::params::mode,
    require => Package['repose-filters'],
  }

  file { '/etc/sysconfig/repose':
    ensure  => file,
    owner   => root,
    group   => root,
    source  => 'puppet:///modules/repose/valve-sysconfig',
    require => [ Class['newrelic'], Package['repose-valve'] ],
    notify  => Service['repose-valve'],
  }

  #file { '/srv/tomcat/webapps/jolokia.war':
  #  ensure  => file,
  #  require => Class['tomcat7'],
  #  source  => 'puppet:///modules/tomcat7/jolokia-war-1.0.5.war'
  #}

  file { '/etc/repose/http-logging.cfg.xml':
    ensure  => file,
    source  => 'puppet:///modules/repose/http-logging.cfg.xml'
  }

  file { '/etc/repose/log4j.properties':
    ensure  => file,
    content => template('repose/log4j.properties.erb')
  }

  file { '/etc/repose/container.cfg.xml':
    ensure  => file,
    content => template('repose/container.cfg.xml.erb')
  }

  file { '/etc/repose/validator.cfg.xml':
    ensure  => file,
    source  => 'puppet:///modules/repose/validator.cfg.xml'
  }

  file { '/etc/repose/response-messaging.cfg.xml':
    ensure  => file,
    source  => 'puppet:///modules/repose/response-messaging.cfg.xml'
  }

}
