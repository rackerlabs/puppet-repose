# == Resource: repose::filter::http_logging
#
# *DEPRECATED* THIS FILTER HAS BEEN DEPRECATED.
# This filter has been replaced with the slf4j http logging filter. Please
# update to use repose::filters::slf4j_http_logging
# This is a resource for generating http logging configuration files
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure config file present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String. Config filename
# Defaults to <tt>http-logging.cfg.xml</tt>
#
# [*log_files*]
# List of Hashes containing id, format, and location
# Defaults to <tt>undef</tt>
#
# === Links
#
# * http://wiki.openrepose.org/display/REPOSE/HTTP+Logging+Filter
#
# === Examples
#
# lint:ignore:140chars
# repose::filter::http_logging {
#   'default':
#     log_files => [
#       { id => 'my-special-log',
#         format => '{&quot;timestamp&quot;: &quot;%t&quot;, &quot;response_time_in_seconds&quot;: %T, &quot;response_code_modifiers&quot;: &quot;%200,201U&quot;, &quot;modifier_negation&quot;: &quot;%!401a&quot;, &quot;remote_ip&quot;: &quot;%a&quot;, &quot;local_ip&quot;: &quot;%A&quot;, &quot;response_size_in_bytes&quot;: %b, &quot;remote_host&quot;: &quot;%h&quot;, &quot;forwarded_for&quot;: &quot;%{x-forwarded-for}i&quot;, &quot;request_method&quot;: &quot;%m&quot;, &quot;server_port&quot;: %p, &quot;query_string&quot;: &quot;%q&quot;, &quot;status_code&quot;: %s, &quot;remote_user&quot;: &quot;%u&quot;, &quot;user_id&quot;: &quot;%{x-user-id}i&quot;, &quot;username&quot;: &quot;%{x-user-name}i&quot;, &quot;tenant_id&quot;: &quot;%{x-tenant-id}i&quot;, &quot;url_path_requested&quot;: &quot;%U&quot;}',
#         location => '/var/log/repose/http_repose.log',
#       },
#       { id => 'credentials-log',
#         format => '%t Requester: %a ForwardedFor: %{x-forwarded-for}i AuthToken: %{x-auth-token}i URL: %U',
#         location => '/var/log/repose/credentials.log',
#       },
#    ];
#   'pre-ratelimit-httplog':
#     filename => 'pre-ratelimit-httplog.cfg.xml',
#     log_files => [
#       { id => 'pre-ratelimit-log',
#         format => '{&quot;timestamp&quot;: &quot;%t&quot;, &quot;response_time_in_seconds&quot;: %T, &quot;response_code_modifiers&quot;: &quot;%200,201U&quot;, &quot;modifier_negation&quot;: &quot;%!401a&quot;, &quot;remote_ip&quot;: &quot;%a&quot;, &quot;local_ip&quot;: &quot;%A&quot;, &quot;response_size_in_bytes&quot;: %b, &quot;remote_host&quot;: &quot;%h&quot;, &quot;forwarded_for&quot;: &quot;%{x-forwarded-for}i&quot;, &quot;request_method&quot;: &quot;%m&quot;, &quot;server_port&quot;: %p, &quot;query_string&quot;: &quot;%q&quot;, &quot;status_code&quot;: %s, &quot;remote_user&quot;: &quot;%u&quot;, &quot;url_path_requested&quot;: &quot;%U&quot;}',
#         location => '/var/log/repose/pre-ratelimit-http.log',
#       }
#    ];
# }
# lint:endignore
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::http_logging (
  String $ensure    = present,
  String $filename  = 'http-logging.cfg.xml',
  $log_files = undef,
) {
  warning('repose::filter::http_logging has been deprecated')

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
## log_files
    if $log_files == undef {
      fail('log_files is a required parameter. see documentation for details.')
    }
    $content_template = template("${module_name}/http-logging.cfg.xml.erb")
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
