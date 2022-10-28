# == Resource: repose::filter::header_normalization
#
# This is a resource for generating header normalization configuration files
# NOTE: The uri-normalization and header-translation filters replace the
# content-normalization filter in repose 7+
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
# [*header_filters*]
# List containing targets, blacklist/whitelists and headers
# Defaults to <tt>undef</tt>
#
# === Links
#
# * https://repose.atlassian.net/wiki/display/REPOSE/Header+Translation+filter
#
# === Examples
#
# repose::filter::uri_normalization {
#   'default':
#     header_filters => [
#       {
#          'http-methods' => 'GET',
#          'blacklists'   => [
#            {
#              'name'   => 'rate-limit-headers',
#              'headers' => [
#                'X-PP-User',
#                'X-PP-Groups',
#             ],
#            }
#         ],
#          'whitelists'   => [
#            {
#              'name'   => 'creds',
#              'headers' => [
#                'X-Auth-Key',
#                'X-Auth-User',
#             ],
#            }
#         ],
#       },
#    ],
# }
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::header_normalization (
  String $ensure         = present,
  String $filename       = 'header-normalization.cfg.xml',
  $header_filters = undef,
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
    $content_template = template("${module_name}/header-normalization.cfg.xml.erb")
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
