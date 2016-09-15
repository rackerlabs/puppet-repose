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
# Required - Hash of Hashes. Allows you to specify which origins are allowed
# to request resources from this server. Nested hashes have values is_regex
# valid values: (true | false), and origin, origin can be a regex if is_regex
# is true, and a full string match of a URL containing port (i.e. 
# https://www.somehost.com:443) 
# Defaults to <tt>{ 10 => { 'is_regex' => 'true', 'origin' => '.*' }</tt>
#
# [*allowed_methods*]
# Array of HTTP VERBS. Allows you to specify which HTTP methods are allowed
# for all resources (when specified under <cross-origin-resource-sharing>).
# Defaults to <tt>undef</tt>
#
# [*resources*]
# Hash of resources, name of hash being the resource path, hash cintains allowed_methods (Array of HTTP verbs) and comment (XML/HTTP style comment). Specifies
# configuration for a resource
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
#     allowed_origins => { 10 => { 'is_regex' => 'true', 'origin' => '.*' },
#     allowed_methods => [ ],
#     resources => { },
# }
#
# === Authors
#
# * Josh Bell <mailto:josh.bell@rackspace.com>
# * c/o Cloud Identity Ops <mailto:identityops@rackspace.com>
#
define repose::filter::cors (
  $ensure          = present,
  $filename        = 'cors.cfg.xml',
  $allowed_origins = { 10 => { 'is_regex' => 'true', 'origin' => '.*' } },
  $allowed_methods = undef, 
  $resources       = undef,
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
    if $allowed_origins == undef {
      fail('allowed_origins is a required parameters. see documentation for details.')
    }
    $content_template = template("${module_name}/cors.cfg.xml.erb")
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
