class repose::saxon {

  File {
    owner => root,
    group => root,
    mode  => '0755',
  }

  file { '/etc/saxon-license.lic':
    ensure => absent,
    force  => true,
  }

  file { '/etc/saxon':
    ensure => directory,
  }

  file { '/etc/saxon/saxon-license.lic':
    ensure  => file,
    mode    => '0644',
    source  => 'puppet:///modules/repose/saxon/repose01us-stage-saxon-license.lic',
    require => File['/etc/saxon'],
  }

  file { '/etc/profile.d/saxon.sh':
    ensure => file,
    source => 'puppet:///modules/repose/saxon.sh',
  }

  file { '/etc/profile.d/saxon.csh':
    ensure => file,
    source => 'puppet:///modules/repose/saxon.csh',
  }

}
