# == Resource: repose::filter::translation
#
# This is a resource for generating translation configuration files
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure config file present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String. Config filename
# Defaults to <tt>translation.cfg.xml</tt>
#
# [*app_name*]
# String. Application name
# Defaults to <tt>repose</tt>
#
# [*request_translations*]
# List containing http_methods, content_type, accept,
# translated_content_type, and a list of styles
# Defaults to <tt>undef</tt>
#
# [*response_translations*]
# List containing content_type, accept, translated_content_type,
# and a list of styles
# Defaults to <tt>undef</tt>
#
# [*xsl-engine*]
# String.  XSL-Engine.
# Defaults to <tt>SaxonHE<tt>
#
# === Links
#
# * http://wiki.openrepose.org/display/REPOSE/Translation
#
# === Examples
#
# === Authors
#
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::translation (
  Enum['present','absent'] $ensure = present,
  String $filename              = 'translation.cfg.xml',
  String $app_name              = 'repose',
  Optional[Any] $request_translations  = undef,
  Optional[Any] $response_translations = undef,
  String $xsl_engine            = 'SaxonHE'
) {
### Validate parameters

## ensure
  $file_ensure = $ensure ? {
    'present' => file,
    'absent'  => 'absent',
  }

  if $ensure == present {
    $content_template = template("${module_name}/translation.cfg.xml.erb")
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
