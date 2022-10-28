# == Resource: repose::filter::destination_router
#
# This is a resource for generating destination_router configuration files
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure config file is present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String. Filename to output config
# Defaults to <tt>destination-router.cfg.xml</tt>
#
# [*targets*]
# Array for target items, should have an id and quality.
# The id specified must match an id of a destination for this service domain, as an endpoint in system-model.cfg.xml.
#   The router will add this id at the specified quality to the list of possible routing destinations for this request.
# The quality factor of a target is a decimal number that must be greater than 0 and less than or equal to 1.0.
#   Repose will evaluate all of the route destinations that have been added to the request and will choose the
#   destination target that has the highest quality.
# Defaults to <tt>undef</tt>
#
# === Links
#
# * https://repose.atlassian.net/wiki/display/REPOSE/Destination+Router+filter
#
# === Examples
#
# repose::filter::destination_router { 'default':
#     targets => [
#       {
#         id => 'openrepose',
#         quality => '0.5',
#       },
#    ]
# }
#
# === Authors
#
# * Vinny Ly <mailto:vinny.ly@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::destination_router (
  String $ensure   = present,
  String $filename = 'destination-router.cfg.xml',
  $targets  = undef,
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
    if $targets == undef {
      fail('targets is a required parameter')
    }
    $content_template = template("${module_name}/destination-router.cfg.xml.erb")
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
