# == Resource: repose::filter::header_translation
#
# This is a resource for generating header
# translation configuration files
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure config file present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String. Config filename
# Defaults to <tt>header-translaction.cfg.xml</tt>
#
# [*app_name*]
# String. Application name
# Defaults to <tt>repose</tt>
#
# [*header_translations*]
# List containing original_name, new_name, remove_original
# Defaults to <tt>undef</tt>
#
# === Links
#
# * http://wiki.openrepose.org/display/REPOSE/Header+Translation
#
# === Examples
#
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::header_translation (
  String $ensure              = present,
  String $filename            = 'header-translation.cfg.xml',
  String $app_name            = 'repose',
  $header_translations = undef,
) {
### Validate parameters

## ensure
  if ! ($ensure in ['present', 'absent']) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
  } else {
    $file_ensure = $ensure ? {
      'present' => file,
      'absent'  => 'absent',
    }
  }

  if $ensure == present {
    $content_template = template("${module_name}/header-translation.cfg.xml.erb")
  } else {
    $content_template = undef
  }
## Manage actions

  file { "${repose::configdir}/${filename}":
    ensure  => $file_ensure,
    owner   => $repose::owner,
    group   => $repose::group,
    mode    => $repose::mode,
    require => Class['repose::package'],
    content => $content_template,
  }
}
