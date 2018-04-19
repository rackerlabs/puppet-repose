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
# [*http_connection_endpoint*]
# String. Set to http endpoint to push traces to.
# Defaults to <tt>http://localhost:12682/api/traces</tt>
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
# Defaults to <tt>off</tt>
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
  $ensure                               = present,
  $filename                             = 'open-tracing.cfg.xml',
  $service_name                         = 'repose',
  $http_connection_endpoint             = 'http://localhost:12682/api/traces',
  $http_connection_username             = undef,
  $http_connection_password             = undef,
  $http_connection_token                = undef,
  $udp_connection_port                  = undef,
  $udp_connection_host                  = undef,
  $constant_toggle                      = 'off',
  $rate_limiting_max_traces_per_second  = undef,
  $probability                          = undef
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
## at least http connection or udp host/port is defined
    if ( $udp_connection_host != undef ) and ( $udp_connection_port != undef ) {
      # validates ipv4 (allows invalid ips), hostname, ipv6 (only standard notation)
      # cannot use validate_ip_* or anything like that since it could be a hostname OR ip address
      validate_re(
        $udp_connection_host, 
        [
          '^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$',
          '^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$',
          '^(?:[A-Fa-f0-9]{0,4}:){7}[A-Fa-f0-9]{1,4}$'
        ],
        'Must provide valid host for udp_connection_host')
      # validate_integer($connection_port) - cannot use validate_integer due to ruby 1.8.7 support.  Comment left here for any future reviewer.
      # Update if we deprecated 1.8.7 support
      if ! is_integer($udp_connection_port) {
        fail( 'connection_port must be an integer' )
      }
    } elsif $http_connection_endpoint != undef {
      validate_re($http_connection_endpoint, 'http?://', 'Must provide valid http:// endpoint for http_connection_endpoint')
      ## if username, then must have password and no token
      if $http_connection_username != undef {
        ## need to check for undef since it validate_string does not check for it.  See https://github.com/puppetlabs/puppetlabs-stdlib#validate_string
        if $http_connection_password == undef {
          fail( 'must define password since username is defined' )
        }
        validate_string($http_connection_username)
        validate_string($http_connection_password)
        if $http_connection_token != undef {
          fail( 'cannot define both token and username for http' )
        }        
      } elsif $http_connection_token != undef {
        validate_string($http_connection_token)
      }
    } else {
      fail( 'either udp or http connection parameters must be defined' )
    }

## at least one of the sampling algos must be defined
    if $rate_limiting_max_traces_per_second != undef {
      if ! is_float($rate_limiting_max_traces_per_second) {
        fail( 'max_traces_per_second must be an float' )
      }
    } elsif $probability != undef {
      if ! is_float($probability) {
        fail( 'probability must be an float' )
      }
    } elsif $constant_toggle != undef {
      validate_re($constant_toggle, ['on','off'], 'constant_toggle must be set to on or off')
    } else {
      fail( 'one of sampling parameters must be defined' )
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
