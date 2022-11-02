# == Resource: repose::filter::versioning
#
# This is a resource for generating versioning configuration files
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure config file present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String. Config filename
# Defaults to <tt>versioning.cfg.xml</tt>
#
# [*app_name*]
# String. Application name
# Defaults to <tt>repose</tt>
#
# [*target_uri*]
# String. The URI of the API repose is proxying
# Defaults to <tt>undef</tt>
#
# [*version_mappings*]
# Hash. Expected keys are 'id', 'status', and 'media_types'
# 
# === Links
#
# * http://wiki.openrepose.org/display/REPOSE/Versioning+Filter
#
# === Examples
#
# repose::filter::versioning {
#   'default':
#     target_uri       => 'http://localhost/repose',
#     version_mappings => [
#       {
#         'id'     => 'v1',
#         'status' => 'CURRENT',
#         'media_types' => [
#           { 'base' => 'application/xml', type => 'application/v1+xml' },
#           { 'base' => 'application/json', type => 'application/v1+json' },
#           { 'base' => 'application/xml', type => 'application/vnd.rackspace; x=v1; y=xml' },
#           { 'base' => 'application/json', type => 'application/vnd.rackspace; x=v1; y=json' },
#           { 'base' => 'application/json', type => 'application/vnd.rackspace; rnd=1; x=v1; rnd2=2; y=xml' },
#           { 'base' => 'application/json', type => 'application/vnd.rackspace; rnd=1; x=v1; rnd2=2; y=json' },
#        ]
#       }
#    ]
# }
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::versioning (
  Enum['present','absent'] $ensure = present,
  String $filename         = 'versioning.cfg.xml',
  String $app_name         = 'repose',
  Optional[String] $target_uri       = undef,
  Optional[Tuple] $version_mappings = undef,

) {
### Validate parameters

## ensure
  $file_ensure = $ensure ? {
    'present' => file,
    'absent'  => 'absent',
  }

  if $ensure == present {
## target_uri
    if $target_uri == undef {
      fail('target_uri is a required parameter')
    }
    $content_template = template("${module_name}/versioning.cfg.xml.erb")
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
