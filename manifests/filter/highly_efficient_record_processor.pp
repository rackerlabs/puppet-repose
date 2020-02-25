# == Resource: repose::filter::highly_efficient_record_processor
#
# This is a resource for generating herp configuration files
#
# === Parameters
#
# [*ensure*]
#   Bool. Ensure config file is present/absent
#   Defaults to <tt>present</tt>
#
# [*filename*]
#   String. Config filename
#   Defaults to <tt>highly-efficient-record-processor.cfg.xml</tt>
#
# [*pre_filter_logger_name*]
#   String. Used to note the SLF4j logger target which can be used in the
#   backend logger configuration to direct it's output to an appender.
#   Defaults to <tt>org.openrepose.herp.pre.filter</tt>.
#
# [*post_filter_logger_name*]
#   String. Used to note the SLF4j logger target which can be used in the
#   backend logger configuration to direct it's output to an appender.
#   Defaults to <tt>org.openrepose.herp.post.filter</tt>.
#
# [*service_code*]
#   String. Used in logging to note the service being accessed.
#   Defaults to <tt>repose</tt>.
#
# [*region*]
#   String. Used in logging to note the region of the service.
#   Defaults to <tt>USA</tt>.
#
# [*datacenter*]
#   String. Used in logging to note the data center of the service.
#   Defaults to <tt>DFW</tt>.
#
# [*template_crush*]
#   Boolean. Indicates whether or not to replace a newline sequence
#   (i.e. \r, \n, \r\n) plus any following whitespace with a single space.
#   Defaults to <tt>false</tt>.
#
# [*template*]
#   String. Mustache-based template used to output events. If set to undef,
#   a CADF formated event is used.
#   Defaults to <tt>undef</tt>.
#
# [*filterOut*]
#   Array of hashes. Contains the set of criteria applied to the events to
#   determine if an event is sent through to the named post filter logger.
#   See example for format.
#   Defaults to <tt>[ ]</tt>.
#
# === Links
#
# * https://repose.atlassian.net/wiki/display/REPOSE/Highly+Efficient+Record+Processor+%28HERP%29+filter
#
# === Examples
#
# repose::filter::highly_efficient_record_processor { 'default':
#   service_code   => 'cloudfeeds',
#   region         => 'US',
#   datacenter     => 'ORD',
#   template_crush => true,
#   filterOut      => [
#     {
#       'match'     => [
#         { 'field' => 'userName', regex => '.*[fF]oo.*' },
#         { 'field' => 'region', regex => 'DFW' },
#       ]
#     },
#     {
#       'match'     => [
#         { 'field' => 'userName', regex => '.*[bB]ar.*' },
#         { 'field' => 'parameters.abc', regex => '123' },
#       ]
#     },
#   ]
# }
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
#
define repose::filter::highly_efficient_record_processor (
  $ensure                  = present,
  $filename                = 'highly-efficient-record-processor.cfg.xml',
  $pre_filter_logger_name  = 'org.openrepose.herp.pre.filter',
  $post_filter_logger_name = 'org.openrepose.herp.post.filter',
  $service_code            = 'repose',
  $region                  = 'US',
  $datacenter              = 'DFW',
  $template_crush          = false,
  $template                = undef,
  $filterOut               = [ ],
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
    $content_template = template("${module_name}/highly-efficient-record-processor.cfg.xml.erb")
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
