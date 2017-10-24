# == Resource: repose::filter::merge_header
#
# This is a resource for generating merge header configuration files
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure config file present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String. Config filename
# Defaults to <tt>merge-header.cfg.xml</tt>
#
# [*request_headers*]
# List containing target headers to merge in the request
# Defaults to <tt>undef</tt>
#
# [*response_headers*]
# List containing target headers to merge in the response
# Defaults to <tt>undef</tt>
#
# === Links
#
# * https://repose.atlassian.net/wiki/display/REPOSE/Merge+Header+filter
#
# === Authors
#
# * Meynard Alconis <mailto:meynard.alconis@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::merge_header (
  $ensure         = present,
  $filename       = 'merge-header.cfg.xml',
  $request_headers = [ ],
  $response_headers = [ ]
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
    $content_template = template("${module_name}/merge-header.cfg.xml.erb")
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
