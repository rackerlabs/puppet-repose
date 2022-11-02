# == Resource: repose::filter::ip_identity
#
# This is a resource for generating ip identity configuration files
#
# === Parameters
#
# [*ensure*]
# Bool.  Ensure config file present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String.  Config filename
# Defaults to <tt>cors.cfg.xml</tt>
#
# [*allowed_origins*]
# Required - Array of Hashes. Allows you to specify which origins are allowed
# to request resources from this server. Nested hashes have values is_regex
# valid values: (true | false), and origin, origin can be a regex if is_regex
# is true, and a full string match of a URL containing port (i.e. 
# https://www.somehost.com:443) 
# Defaults to <tt>[{ 'is_regex' => 'true', 'origin' => '.*' }]</tt>
#
# [*allowed_methods*]
# Array of HTTP VERBS. Allows you to specify which HTTP methods are allowed
# for all resources (when specified under <cross-origin-resource-sharing>).
# Defaults to <tt>undef</tt>
#
# [*resources*]
# Specifies configuration for a resource
# Array of Hashes of resources, each hash containing the keys, name of hash
# being the resource path, allowed_methods (Array of HTTP verbs) and optional
# comment (XML/HTTP style comment).
# Defaults to <tt>undef</tt>
#
# === Links
#
# * https://repose.atlassian.net/wiki/display/REPOSE/CORS+Filter
#
# === Examples
#
# repose::filter::cors {
#   'default':
#     allowed_origins => [{ 'is_regex' => 'true', 'origin' => '.*' }],
#     allowed_methods => [],
#     resources => [],
# }
#
# === Authors
#
# * Josh Bell <mailto:josh.bell@rackspace.com>
# * c/o Cloud Identity Ops <mailto:identityops@rackspace.com>
#
define repose::filter::cors (
  Enum['present','absent'] $ensure = present,
  String $filename        = 'cors.cfg.xml',
  Array[Hash] $allowed_origins = [{ 'is_regex' => 'true', 'origin' => '.*' }],
  Optional[Array] $allowed_methods = undef,
  Optional[Array] $resources       = undef,
) {
### Validate parameters

## ensure
  $file_ensure = $ensure ? {
    'present' => file,
    'absent'  => 'absent',
  }

  if $ensure == present {
    if $allowed_origins == undef {
      fail('allowed_origins is a required parameters. see documentation for details.')
    }
    $content_template = template("${module_name}/cors.cfg.xml.erb")
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
