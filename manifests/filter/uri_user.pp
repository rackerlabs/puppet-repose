# == Resource: repose::filter::uri_identity
#
# This is a resource for generating uri identity filter config files
#
# === Parameters
#
# [*ensure*]
# Bool.  Ensure config file present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String.  Config filename
# Defaults to <tt>uri-user.cfg.xml</tt>
#
# [*quality*]
# Float, Defines the quality assigned to user by the incoming identification
# data. This value resolves the order of preference when multiple identity
# filters are used so that the rate limiting filter knows which identity to
# limit by. Should be a value between 0.0 and 1.0.
# Defaults to <tt>undef</tt>
#
# [*mappings*]
# Array of hashes each hash has keys of id (String) and regex (String) a regex
# matching an endpoint location. Required.
# Defaults to <tt>undef</tt>
#
# [*group*]
# String, Name for the group that is supplied to the X-PP-Group Header when
# filter matches.
# Defaults to <tt>undef</tt>
#
# === Links
#
# * https://repose.atlassian.net/wiki/display/REPOSE/URI+User+filter
#
# === Examples
#
# repose::filter::uri_user {
#   'default':
#     quality => 0.8,
#     mappings => [
#        { "id" => "main", "regex" => ".*" },
#     ]
# }
#
# === Authors
#
# * Josh Bell <nailto:josh.bell@rackspace.com>
# * c/o Cloud Identity Ops <mailto:identityops@rackspace.com>
#
define repose::filter::uri_user (
  Array[Hash] $mappings,
  Enum['present','absent'] $ensure        = present,
  String $filename      = 'uri-user.cfg.xml',
  Optional[String] $group         = undef,
  Optional[Variant[String,Float]] $quality       = undef,
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
    $content_template = template("${module_name}/uri-user.cfg.xml.erb")
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
