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
# [*service_name*]
# String. Application name
# Defaults to <tt>repose</tt>
#
# [*http_connection_endpoint*]
# String. Set to http endpoint to push traces to.
# Defaults to <tt>undef</tt>
#
# [*http_connection_username*]
# String. Set if http endpoint requires username/password authentication.  Must be used in conjunction with password
# Defaults to <tt>undef</tt>
#
# [*http_connection_password*]
# String. Set if http endpoint requires username/password authentication.  Must be used in conjunction with username
# Defaults to <tt>undef</tt>
#
# [*http_connection_token*]
# String. Set if http endpoint requires token authentication.
# Defaults to <tt>undef</tt>
#
# [*udp_connection_port*]
# Integer. Set to port the agent is listening on.  Used in tandem with udp_connection_host.
# Defaults to <tt>undef</tt>
#
# [*udp_connection_host*]
# String. Set to host the agent is listening on.  Used in tandem with udp_connection_port.
# Defaults to <tt>undef</tt>
#
# [*constant_toggle*]
# String that sets constant sampling. Can be 'on' or 'off'
# Defaults to <tt>undef</tt>
#
# [*rate_limiting_max_traces_per_second*]
# Double. Set to the maximum traces to sample per second.  Sets rate-limiting sampling algorithm.
# Defaults to <tt>undef</tt>
#
# [*probability*]
# Double. Set to probability sampling rate.  Ranges from 0.0 to 1.0.  Sets rate-limiting probabilistic algorithm.
# Defaults to <tt>undef</tt>
#
# === Links
#
# * http://www.openrepose.org/versions/latest/services/open-tracing.html
#
# === Examples
#
# repose::filter::open_tracing {
#  'open_tracing':
#     service_name => 'awesome-repose',
#     http_connection_endpoint => 'https://jaeger-collector.example.com/api/traces',
#     constant_toggle => 'on'
# }
#
# === Authors
#
# * Dimitry Ushakov <mailto:dimitry-ushakov@rackspace.com>
#
define repose::filter::open_tracing (
  Enum['present','absent'] $ensure                               = present,
  String $service_name                         = 'repose',
  Optional[Stdlib::HTTPUrl] $http_connection_endpoint             = undef,
  Optional[String] $http_connection_username             = undef,
  Optional[String] $http_connection_password             = undef,
  Optional[String] $http_connection_token                = undef,
  Optional[Stdlib::Port] $udp_connection_port                  = undef,
  Optional[Stdlib::Host] $udp_connection_host                  = undef,
  Optional[Enum['on','off']] $constant_toggle                      = undef,
  Optional[Float] $rate_limiting_max_traces_per_second  = undef,
  Optional[Float] $probability                          = undef
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
    # if we have nothing to connect to, why even bother

    if (( $udp_connection_host != undef ) and ( $udp_connection_port == undef ) or ( $udp_connection_host == undef ) and ( $udp_connection_port != undef )) {
      fail ('udp host and udp port must both be defined')
    }

    if (( $udp_connection_host == undef ) and ( $udp_connection_port == undef )) and ( $http_connection_endpoint == undef ){
      fail( 'either udp or http connection parameters must be defined' )
    }
    # if endpoint, then user/pass or token
    if $http_connection_endpoint != undef {
      ## if username, then must have password and no token
      if $http_connection_username != undef {
        if $http_connection_password == undef {
          fail( 'must define password since username is defined' )
        }
        if $http_connection_token != undef {
          fail( 'cannot define both token and username for http' )
        }
      }
    }

  ## at least one of the sampling algos must be defined
    if ($rate_limiting_max_traces_per_second == undef) and ($probability == undef) and ($constant_toggle == undef) {
      fail( 'one of sampling parameters must be defined' )
    }
    $content_template = template("${module_name}/open-tracing.cfg.xml.erb")
  } else {
    $content_template = undef
  }

## Manage actions
  file { "${repose::configdir}/open-tracing.cfg.xml":
    ensure  => $file_ensure,
    owner   => $repose::owner,
    group   => $repose::group,
    mode    => $repose::mode,
    require => Class['::repose::package'],
    content => $content_template
  }
}
