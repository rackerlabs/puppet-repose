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
#         ]
#       }
#     ],
#     media_types => [
#       {
#         'name'              => 'application/xml',
#         'variant-extension' => 'xml'
#       },
#       {
#         'name'              => 'application/json',
#         'variant-extension' => 'json'
#       },
#     ]
# }
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::content_normalization (
  $ensure                = present,
  $filename              = 'content-normalization.cfg.xml',
  $app_name              = 'repose',
  $content_normalization = undef,
  $header_filters        = undef,
  $media_types           = undef,
) {

  warning("${name} - content normalization filter is incompatibile with repose 7+")

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
    $content_template = template("${module_name}/content-normalization.cfg.xml.erb")
  } else {
    $content_template = undef
  }
## Manage actions

  file { "${repose::params::configdir}/${filename}":
    ensure  => $file_ensure,
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Package['repose-filters'],
    content => $content_template
  }

}
