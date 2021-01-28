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
# === Links
#
# * http://wiki.openrepose.org/pages/viewpage.action?pageId=1048835
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
  Enum['present','absent'] $ensure                = present,
  String $filename              = 'compression.cfg.xml',
  Integer $threshold             = 1024,
  Boolean $debug                 = false,
  Array $include_content_types = [ 'text/html', ],
  Optional[Array] $exclude_content_types = undef
) {

### Validate parameters

## ensure
  $file_ensure = $ensure ? {
    present => file,
    absent  => absent,
  }

  if $::debug {
    debug("\$ensure = '${ensure}'")
  }

  if $ensure == present {
    $content_template = template("${module_name}/compression.cfg.xml.erb")
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
