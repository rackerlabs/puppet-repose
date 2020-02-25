# == Resource: repose::filter::uri_normalization
#
# This is a resource for generating uri normalization configuration files
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
# [*uri_filters*]
# Array of hashes containing array of hashes of targets, whitelists and
# parameters.  See documentation and example for hash structure.
# Defaults to <tt>undef</tt>
#
# [*media_types*]
# List of media_types, each containing name, variant-extension, preferred
# Defaults to <tt>undef</tt>
#
# === Links
#
# * https://repose.atlassian.net/wiki/display/REPOSE/URI+Normalization+filter
#
# === Examples
#
# repose::filter::uri_normalization {
#   'default':
#     uri_filters => [
#       {
#          'uri-regex'    => '',
#          'http-methods' => 'GET',
#          'alphabetize'  => 'false',
#          'whitelists'   => [
#            {
#              'id'         => 'something',
#              'parameters' => [
#                {
#                  'name'           => 'test',
#                  'multiplicity'   => '0',
#                  'case-sensitive' => 'false',
#                }
#              ],
#            }
#          ],
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
define repose::filter::uri_normalization (
  $ensure      = present,
  $filename    = 'uri-normalization.cfg.xml',
  $uri_filters = undef,
  $media_types = undef,
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
    $content_template = template("${module_name}/uri-normalization.cfg.xml.erb")
  } else {
    $content_template = undef
  }
## Manage actions

  file { "${repose::configdir}/${filename}":
    ensure  => $file_ensure,
    owner   => $repose::owner,
    group   => $repose::group,
    mode    => $repose::mode,
    require => Class['::repose::package'],
    content => $content_template
  }

}
