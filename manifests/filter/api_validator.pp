# == Resource: repose::filter::api_validator
#
# This is a resource for generating validator configuration files
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure config file is present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String. Config filename
# Defaults to <tt>validator.cfg.xml</tt>
#
# [*app_name*]
#
# [*validators*]
# List containing list of validator options
#
# [*validators::validator*]
# List containing role, applications and resources
#
# [*multi_role_match*]
# boolean string
#
# [*version*]
# Version number for the validator configuration
#
# === Examples
#
# repose::filter::api_validator {
#  'api_validator':
#     multi_role_match => true,
#     validators => [
#     {
#       'role'                         => 'app',
#       'default'                      => true,
#       'wadl'                         => 'usage-schema/app.wadl',
#       'check_well_formed'            => true,
#       'remove_dupes'                 => true,
#       'check_xsd_grammar'            => true,
#       'check_elements'               => true,
#       'xpath_version'                => 2,
#       'check_plain_params'           => true,
#       'do_xsd_grammar_transform'     => true,
#       'enable_pre_process_extension' => true,
#       'xsl_engine'                   => 'XalanC',
#       'xsd_engine'                   => 'SaxonEE',
#       'dot_output'                   => '/var/repose/validator.dot',
#       'join_xpatch_checks'           => true,
#     }, ]
# }
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::api_validator (
  $ensure           = present,
  $filename         = 'validator.cfg.xml',
  $app_name         = 'repose',
  $validators       = undef,
  $multi_role_match = false,
  $version          = undef,
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

## validators
  if $validators == undef {
    fail('validators is a required list')
  }


## Manage actions

  file { "${repose::params::configdir}/${filename}":
    ensure  => $file_ensure,
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Package['repose-filters'],
    content => template('repose/validator.cfg.xml.erb'),
  }

}
