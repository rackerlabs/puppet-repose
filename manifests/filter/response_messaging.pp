# == Resource: repose::filter::response_messaging
#
# This is a resource for generating response-messaging configuration files
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
# [*status_codes*]
# Array of hashes.  The hash contains an id, code-regex, and overwrite and an 
# array of message hashes.
# Defaults to <tt>undef</tt>
#
# [*status_codes::messages*]
# Array of hashes.  This message hash contains media-type, content-type and, href and body.  
# 
# === Links
#
# * http://wiki.openrepose.org/display/REPOSE/Response+Messaging+Service
# 
# === Examples
#
# repose::filter::response_messaging { 'default':
#   status_codes  => [
#     {
#       'id'         => '413',
#       'code-regex' => '413',
#       'messages'   => [
#         {
#           'media-type' => '*/*',
#           'body' => '{ "overLimit" : { "code" : 413, "message" : "OverLimit Retry...", "details" : "whatever": } }', 
#         }
#       ]
#     }, 
#   ]
# }
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::response_messaging (
  $ensure           = present,
  $filename         = 'response-messaging.cfg.xml',
  $app_name         = 'repose',
  $status_codes     = undef,
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
## validators
    if $status_codes == undef {
      fail('status_codes is a required list')
    }
    $content_template = template("${module_name}/response-messaging.cfg.xml.erb")
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
