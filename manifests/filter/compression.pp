# == Resource: repose::filter::compression
#
# This is a resource for generating compression configuration files
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure file is present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String.  Config filename
# Defaults to <tt>compression.cfg.xml</tt>
#
# [*threshold*]
# Integer. Compression threshold
# Defaults to <tt>1024</tt>
#
# [*debug*]
# Bool. Debug parameters
# Defaults to <tt>false</tt>
#
# [*include_content_types*]
# Array of media types that will be compressed if possible. Required.
# Defaults to <tt>[ "text/html" ]</tt>
#
# [*exclude_content_types*]
# Array of media types to be excluded from compression. Optional.
# Defaults to <tt>undef</tt>
#
# === Examples
#
# repose::filter::compression {
#   'default':
#     include_content_types => [ "application/atom+xml" ]
# }
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::compression (
  $ensure                = present,
  $filename              = 'compression.cfg.xml',
  $threshold             = 1024,
  $debug                 = false,
  $include_content_types = [ 'text/html', ],
  $exclude_content_types = undef
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

## Manage actions

  file { "${repose::params::configdir}/${filename}":
    ensure  => $file_ensure,
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Package['repose-filters'],
    content => template('repose/compression.cfg.xml.erb'),
  }

}
