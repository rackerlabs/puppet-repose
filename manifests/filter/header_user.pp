# == Resource: repose::filter::header_user
#
# This is a resource for generating header-user configuration files
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure config file present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String. Config filename
# Defaults to <tt>header-user.cfg.xml</tt>
#
# [*source-headers*]
# Array of hashes containing source headers with the ids of the source headers and their
# coresponding values
# Example:
# [
#   {
#     'name'  => 'X-Auth-Token',
#     'value' => '.90',
#   },{
#     'name'  => 'X-PP-User'
#     'value' => '.07',
#   },{
#     'name'  => 'X-User-Name',
#     'value' => '.03',
#   },
# ]
#
# === Links
#
# *
#
# === Authors
#
# * Senthil Natarajan <mailto:senthil.natarajan@rackspace.com>
# * Joel Rizner <mailto:joel.rizner@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::header_user (
  $ensure         = present,
  $filename       = 'header-user.cfg.xml',
  $source_headers = [],
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
    validate_array($source_headers)

    $content_template = template("${module_name}/header-user.cfg.xml.erb")
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
