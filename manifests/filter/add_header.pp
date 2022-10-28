# == Resource: repose::filter::add_header
#
# This is a resource for generating add-header configuration files
#
# === Parameters
#
# [*ensure*]
#   Bool. Ensure config file is present/absent
#   Defaults to <tt>present</tt>
#
# [*filename*]
#   String. Config filename
#   Defaults to <tt>validator.cfg.xml</tt>
#
# [*request_headers*]
#   Array. An array of headers to add to the request.
#   Defaults to <tt>[]</tt>.
#
# [*response_headers*]
#   Array. An array of headers to add to the response.
#   Defaults to <tt>[]</tt>.
#
# === Links
#
# * https://repose.atlassian.net/wiki/display/REPOSE/Add+Header+Filter
#
# === Examples
#
# repose::filter::add_header { 'default':
#   request_headers => [
#     {
#       name      => 'repose-test',
#       overwrite => false,
#       quality   => '0.5',
#       value     => 'this-is-a-test',
#     },
#     {
#       name      => 'overwrite-test',
#       overwrite => true,
#       quality   => '0.5',
#       value     => 'this-is-overwrite-value',
#     },
#  ],
#   reponse_headers => [
#     {
#       name      => 'reponse-header',
#       overwrite => false,
#       quality   => '0.9',
#       value     => 'foooo',
#     },
#  ],
# }
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
#
define repose::filter::add_header (
  String $ensure           = present,
  String $filename         = 'add-header.cfg.xml',
  Array $request_headers  = [],
  Array $response_headers = [],
) {
### Validate parameters

## ensure
  if ! ($ensure in ['present', 'absent']) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
  } else {
    $file_ensure = $ensure ? {
      'present' => file,
      'absent'  => 'absent',
    }
  }

  if $ensure == present {
## validators
    $content_template = template("${module_name}/add-header.cfg.xml.erb")
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
