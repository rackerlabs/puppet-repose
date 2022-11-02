# == Resource: repose::filter::content_normalization
#
# This is a resource for generating content-normalization configuration files
# DEPRECATED: This has been removed from repose 7+, use URI normalization and
# header normalization filters instead.
# See: https://repose.atlassian.net/wiki/display/REPOSE/Upgrade+Repose
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure file present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String. Config filename
# Defaults to <tt>content-normalization.cfg.xml</tt>
#
# [*app_name*]
# String. Application name.
# Defaults to <tt>repose</tt>
#
# [*header_filters*]
# List of filters containing name, id, headers
#
# [*media_types*]
# List of media_types, each containing name, variant-extension, preferred
#
# === Links
#
# * http://wiki.openrepose.org/display/REPOSE/Content+Normalization
#
# === Examples
#
# repose::filter::content_normalization {
#   'default':
#     header_filters => [
#       {
#         name    => 'blacklist',
#         id      => 'ReposeHeaders',
#         headers => [
#           'X-Authorization',
#           'X-User-Name',
#        ]
#       }
#    ],
#     media_types => [
#       {
#         'name'              => 'application/xml',
#         'variant-extension' => 'xml'
#       },
#       {
#         'name'              => 'application/json',
#         'variant-extension' => 'json'
#       },
#    ]
# }
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::content_normalization (
  Enum['present','absent'] $ensure = present,
  String $filename              = 'content-normalization.cfg.xml',
  String $app_name              = 'repose',
  Optional[Any] $content_normalization = undef,
  Optional[Array] $header_filters        = undef,
  Optional[Array] $media_types           = undef,
) {
  warning("${name} - content normalization filter is incompatibile with repose 7+")

### Validate parameters

## ensure
  $file_ensure = $ensure ? {
    'present' => file,
    'absent'  => 'absent',
  }

  if $ensure == present {
    $content_template = template("${module_name}/content-normalization.cfg.xml.erb")
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
