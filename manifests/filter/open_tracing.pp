# == Resource:  repose::filter::open_tracing
#
# This is a resource for enabling emitting traces to an OpenTracing tracer (current supports Jaeger).
# Only usable in >= 8.8.3.0
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure config file present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String. Config filename.
# Defaults to <tt>open-tracing.cfg.xml</tt>
#
# [*service_name*]
# String. Application name
# Defaults to <tt>repose</tt>
#
# [*connection_http*]
# Object that sets up http connection.  Contains endpoint, username, password, and token
# Defaults to <tt>undef</tt>
#
# [*endpoint*]
# String. Set to http endpoint to push traces to.  Required if using http connection.
# Defaults to <tt>undef</tt>
#
# [*username*]
# String. Set if http endpoint requires username/password authentication.  Must be used in conjunction with password
# Defaults to <tt>undef</tt>
#
# [*password*]
# String. Set if http endpoint requires username/password authentication.  Must be used in conjunction with username
# Defaults to <tt>undef</tt>
#
# [*token*]
# String. Set if http endpoint requires token authentication.
# Defaults to <tt>undef</tt>
#
# [*connection_udp*]
# Object that sets up udp connection.  Contains host and port.
# Defaults to <tt>undef</tt>
#
# [*port*]
# Integer. Set to port the agent is listening on.
# Defaults to <tt>undef</tt>
#
# [*host*]
# String. Set to host the agent is listening on.
# Defaults to <tt>undef</tt>
#
# [*sampling_constant*]
# Object that sets constant sampling. Contains toggle attribute
# Defaults to <tt>undef</tt>
#
# [*toggle*]
# String. Set to 'off' to turn off sampling completely.  Set to 'on' to sample every trace from this service.
# Defaults to <tt>on</tt>
#
# [*sampling_rate_limiting*]
# Object that sets rate limiting sampling. Contains max_traces_per_second attribute
# Defaults to <tt>undef</tt>
#
# [*max_traces_per_second*]
# Double. Set to the maximum traces to sample per second.  If not defined, uses default of 1.0
# Defaults to <tt>1.0</tt>
#
# [*sampling_probabilistic*]
# Object that sets probabilistic sampling. Contains probability attribute
# Defaults to <tt>undef</tt>
#
# [*probability*]
# Double. Set to probability sampling rate.  Ranges from 0.0 to 1.0.  Defaults to 0.001, which is equivalent to 1 trace for every 1000 being sampled.
# Defaults to <tt>0.001</tt>
#
# === Links
#
# * http://www.openrepose.org/versions/latest/services/open-tracing.html
#
# === Examples
#
# repsoe::filter::open_tracing {
#  'open_tracing':
#     service_name => 'awesome-repose',
#     connection_http => {
#       'endpoint' => 'https://jaeger-collector.example.com/api/traces'
#     },
#     sampling_constant =>  {
#       'toggle' => 'on'
#     }
# }
#
# === Authors
#
# * Dimitry Ushakov <mailto:dimitry-ushakov@rackspace.com>
#
define repose::filter::open_tracing (
  $ensure                 = present,
  $filename               = 'open-tracing.cfg.xml',
  $service_name           = 'repose',
  $connection_http        = undef,
  $connection_udp         = undef,
  $sampling_constant      = undef,
  $sampling_probabilistic = undef,
  $sampling_rate_limiting = undef
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
## at least http or udp is on
    if !$connection_http and !$connection_udp {
      fail( 'either connection_http or connection_udp must be set' )
    }

## if http
    if $connection_http {
      ## must have endpoint
      if !$connection_http['endpoint'] {
        fail( 'must define http endpoint for connection_http' )
      }

      ## if username, then must have password and no token
      if $connection_http['username'] {
        if !$connection_http['password'] {
          fail( 'must define password since username is defined for connection_http' )
        }
        if $connection_http['token'] {
          fail( 'cannot define both token and username for connection_http' )
        }        
      }
    } else {
      if !$connection_udp['host'] or !$connection_udp['port'] {
        fail( 'must specify host and port for connection_udp' )
      }
    }

## at least one of the sampling algos must be defined
    if !$sampling_probabilistic and !$sampling_rate_limiting and !$sampling_constant {
      fail( 'must define at a sampling algorithm' )
    }

    $content_template = template("${module_name}/open-tracing.cfg.xml.erb")
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
