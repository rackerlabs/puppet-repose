# == Resource: repose::filter::scripting
#
# This is a resource for generating scripting filter configuration files
# Requires experimental_filters parameter to be true as this filter is
# provided by the experiemental filters bundle package.
#
# === Parameters
#
# [*ensure*]
# Bool.  Ensure config file present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String.  Config filename
# Defaults to <tt>scripting.cfg.xml</tt>
#
# [*script_lang*]
# String, the language used in the additional scripting, currely only groovy,
# javascript, python, ruby, and LUA are supported by repose.
# Defaults to <tt>undef</tt>
#
# [*mod_script*]
# String, The script in the language set in script_lang used to modify
# the request/response. Script must be in the language set in script_lang
# Defaults to <tt>undef</tt>
#
# === Links
#
# * https://repose.atlassian.net/wiki/display/REPOSE/Scripting+Filter
#
# === Examples
#
# repose::filter::scripting {
#   'default':
#     script_lang  => 'groovy',
#     mod_script   => 'request.addHeader("foo", "bar")'
# }
#
# === Authors
#
# * Josh Bell <mailto:josh.bell@rackspace.com>
# * c/o Cloud Identity Ops <mailto:identityops@rackspace.com>
#
define repose::filter::scripting (
  $ensure      = present,
  $filename    = 'scripting.cfg.xml',
  $script_lang = undef,
  $mod_script  = undef,
) {

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

  if $ensure == present {
      
    if $script_lang == undef {
      fail('script_lang is a required parameter. see documentation for details.')
    }

    if $mod_script == undef {
      fail('mod_script is a required parameter. see documentation for details.')
    }

    $content_template = template("${module_name}/scripting.cfg.xml.erb")
  } else {
    $content_template = undef
  }

## Manage actions

  file { "${repose::params::configdir}/${filename}":
    ensure  => $file_ensure,
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Class['::repose::package'],
    content => $content_template
  }

}
