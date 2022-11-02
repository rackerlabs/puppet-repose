# == Resource: repose::filter::rate_limiting
#
# This is a resource for generating rate limiting configuration files
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure config file present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String. Config filename
# Defaults to <tt>rate-limiting.cfg.xml</tt>
#
# [*datastore*]
# String. Which distributed datastore to use for storing maintaining
# the rate limit information.
#
# [*overlimit_429*]
# Boolean.  "overLimit-429-responseCode" set to true will send 429
# response code instead of default 413 response code which in
# conjunction with Response Messaging Service Configuration for 429
# status code will provide custom over limit message . As 429
# response code is proposed HTTP standard code and servlet containers
# return 429 as response message.
# Defaults to <tt>undef</tt>
#
# [*use_capture_groups*]
# Boolean. "use-capture-groups" set to false will count all the requests
# with the uri-regex that has the capture group towards the limit count
# specified. In other words, if "use-capture-groups" is set to false,
# the first rate limit with a uri-regex that matches the request URI will
# be used to apply the rate limit. By default it is set to true.
# Defaults to <tt>true</tt>
#
# [*request_endpoint*]
# Required Hash.  Contains String(uri-regex) and Boolean(include-absolute-limits)
#
# [*limit_groups*]
# Required Array of hashes.  Hashes should contain
#   String(id), String(groups), Boolean(default), and ArrayofHashes(limits)
# Where the hashes in limits should contain the Strings:
#   uri, uri-regex, http-methods, unit, value, id
# NOTE: the id in limits array  should only be used with repose 5.0.0+.
# Setting id <5.0.0 will result in the error.
#
# === Links
#
# * http://wiki.openrepose.org/display/REPOSE/Rate+Limiting+Filter
#
# === Examples
#
# repose::filter::rate_limiting {
#   'default':
#     overlimit_429 => true,
#     request_endpoint => {
#      'uri-regex' => '/limits/userrs/?',
#      'include_absolute_limits' => false,
#     },
#     limit_groups => [
#       { 'id' => 'UserIdentity_Group',
#         'groups' => 'UserIdentity_Group',
#         'default' => true,
#         'limits' => [
#           {
#             'uri' => '/sites/events*',
#             'uri_regex' => '/(sites)/events',
#             'http_methods' => 'POST',
#             'unit' => 'SECOND',
#             'value'=> '675',
#           },
#           {
#             'uri' => '/files/events*',
#             'uri_regex' => '/(files)/events',
#             'http_methods' => 'POST',
#             'unit' => 'SECOND',
#             'value'=> '200',
#           },
#           {
#             'uri' => '^/(?!.*test).*/events*',
#             'uri_regex' => '^/*?!.*test)(.*)/events*',
#             'http_methods' => 'POST',
#             'unit' => 'SECOND',
#             'value'=> '200',
#           },
#           {
#             'uri' => '^/(?!.*test).*/events*',
#             'uri_regex' => '^/*?!.*test)(.*)/events*',
#             'http_methods' => 'GET',
#             'unit' => 'SECOND',
#             'value'=> '350',
#            },
#        ]
#       },
#    ],
# }
#
# === Links
#
# * http://wiki.openrepose.org/display/REPOSE/Rate+Limiting+Filter
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::rate_limiting (
  Enum['present','absent'] $ensure = present,
  String $filename           = 'rate-limiting.cfg.xml',
  $datastore          = undef,
  $overlimit_429      = undef,
  Boolean $use_capture_groups = true,
  $request_endpoint   = undef,
  $limit_groups       = undef,
) {
### Validate parameters

## ensure
  $file_ensure = $ensure ? {
    'present' => file,
    'absent'  => 'absent',
  }

  if $ensure == present {
## request_endpoint
    if $request_endpoint == undef {
      fail('request_endpoint is a required parameter. see documentation for details.')
    }

## limit_groups
    if $limit_groups == undef {
      fail('limit_groups is a required parameter. see documentation for details.')
    }
    $content_template = template("${module_name}/rate-limiting.cfg.xml.erb")
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
