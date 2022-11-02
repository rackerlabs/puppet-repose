# == Class: repose::package
#
# This class exists to coordinate all software package management related
# actions, functionality and logical units in a central place.
#
#
# === Parameters
#
# [*ensure*]
# String. Controls if the managed resources shall be <tt>present</tt>,
# <tt>absent</tt>, <tt>latest</tt> or a version nuymber. If set to
# <tt>absent</tt>:
# * The managed software packages are being uninstalled.
# * Any traces of the packages will be purged as good as possible. This may
# include existing configuration files. The exact behavior is provider
# dependent. Q.v.:
# * Puppet type reference: {package, "purgeable"}[http://j.mp/xbxmNP]
# * {Puppet's package provider source code}[http://j.mp/wtVCaL]
# * System modifications (if any) will be reverted as good as possible
# (e.g. removal of created users, services, changed log settings, ...).
# * This is thus destructive and should be used with care.
# Defaults to <tt>present</tt>.
#
# [*experimental_filters*]
# Boolean. Install the experimental filters bundle package
# Defaults to <tt>false</tt>
#
# [*experimental_filters_packages*]
# Array. The experimental filters packageas to install.
# 
# [*identity_filters*]
# Boolean. Install the identity filters bundle package
# Defaults to <tt>false</tt>
#
# [*identity_filters_packages*]
# Array. The identity filters packageas to install.
# 
# === Examples
#
# Primarily to be used by the repose base class, but you can use:
#   class { 'repose::package': container => 'valve' }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
# === Authors
#
# * Josh Bell <mailto:josh.bell@rackspace.com>
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
# * c/o Cloud Identity Ops <mailto:identityops@rackspace.com>
#
class repose::package (
) {
### Logic

### Manage actions
  package { $repose::package_name:
    ensure          => $repose::ensure,
    install_options => ['--nogpgcheck'],
  }

  package { $repose::packages:
    ensure          => $repose::ensure,
    require         => Package[$repose::package_name],
    install_options => ['--nogpgcheck'],
  }

  if $repose::experimental_filters == true {
    package { $repose::experimental_filters_packages:
      ensure          => $repose::ensure,
      require         => Package[$repose::package_name],
      install_options => ['--nogpgcheck'],
    }
  } else {
    package { $repose::experimental_filters_packages:
      ensure  => 'absent',
      require => Package[$repose::package_name],
    }
  }

  if $repose::identity_filters == true {
    package { $repose::identity_filters_packages:
      ensure          => $repose::ensure,
      require         => Package[$repose::package_name],
      install_options => ['--nogpgcheck'],
    }
  }
}
