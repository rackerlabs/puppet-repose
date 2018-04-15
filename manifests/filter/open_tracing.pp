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
# [*connection_type*]
# String that sets up opentracing connection.  Can be either http or udp
# Defaults to <tt>udp</tt>
#
# [*connection_endpoint*]
# String. Set to http endpoint to push traces to.  Required if using http connection.
# Defaults to <tt>http://localhost:12682/api/traces</tt>
#
# [*connection_username*]
# String. Set if http endpoint requires username/password authentication.  Must be used in conjunction with password
# Defaults to <tt>undef</tt>
#
# [*connection_password*]
# String. Set if http endpoint requires username/password authentication.  Must be used in conjunction with username
# Defaults to <tt>undef</tt>
#
# [*connection_token*]
# String. Set if http endpoint requires token authentication.
# Defaults to <tt>undef</tt>
#
# [*connection_port*]
# Integer. Set to port the agent is listening on.  Required if using udp connection.
# Defaults to <tt>5775</tt>
#
# [*connection_host*]
# String. Set to host the agent is listening on.  Required if using udp connection.
# Defaults to <tt>localhost</tt>
#
# [*sampling_type*]
# String that sets up opentracing sampling algorithm.  Can be constant, probabilistic, or rate-limiting
# Defaults to <tt>constant</tt>
#
# [*constant_toggle*]
# String that sets constant sampling. Can be 'on' or 'off'
# Defaults to <tt>off</tt>
#
# [*max_traces_per_second*]
# Double. Set to the maximum traces to sample per second.  If not defined, uses default of 1.0
# Defaults to <tt>1.0</tt>
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
#     connection_type => 'http',
#     connection_endpoint => 'https://jaeger-collector.example.com/api/traces',
#     sampling_type => 'constant',
#     constant_toggle => 'on'
# }
#
# === Authors
#
# * Dimitry Ushakov <mailto:dimitry-ushakov@rackspace.com>
#
define repose::filter::open_tracing (
  $ensure                   = present,
  $filename                 = 'open-tracing.cfg.xml',
  $service_name             = 'repose',
  $connection_type          = 'udp',
  $connection_endpoint      = 'http://localhost:12682/api/traces',
  $connection_username      = undef,
  $connection_password      = undef,
  $connection_token         = undef,
  $connection_port          = 5775,
  $connection_host          = 'localhost',
  $sampling_type            = 'constant',
  $constant_toggle          = 'off',
  $max_traces_per_second    = 1.0,
  $probability              = 0.001
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
    validate_re($connection_type, ['http','udp'], 'connection_type parameter must be either http or udp')
    if $connection_type == 'http' {
      validate_re($connection_endpoint, 'http?://', 'Must provide valid http:// endpoint for connection_endpoint for connection_type http')
      ## if username, then must have password and no token
      if $connection_username != undef {
        ## need to check for undef since it validate_string does not check for it.  See https://github.com/puppetlabs/puppetlabs-stdlib#validate_string
        if $connection_password == undef {
          fail( 'must define password since username is defined for http connection_type' )
        }
        validate_string($connection_username)
        validate_string($connection_password)
        if $connection_token != undef {
          fail( 'cannot define both token and username for http connection_type' )
        }        
      } elsif $connection_token != undef {
        validate_string($connection_token)
      }
    } elsif $connection_type == 'udp' {
      # validates ipv4 (allows invalid ips), hostname, ipv6 (only standard notation)
      validate_re(
        $connection_host, 
        [
          '^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$',
          '^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$',
          '^(?:[A-Fa-f0-9]{0,4}:){7}[A-Fa-f0-9]{1,4}$'
        ],
        'Must provide valid host for connection_host for connection_type udp')
      validate_integer($connection_port)
    }

## at least one of the sampling algos must be defined
    validate_re($sampling_type, ['constant','probabilistic','rate-limiting'], 'sampling_type parameter must be one of constant, probabilistic, or rate-limting')
    if $sampling_type == 'constant' {
      validate_re($constant_toggle, ['on','off'], 'constant_toggle must be set to on or off')
    } elsif $sampling_type == 'rate-limiting' {
      validate_numeric($max_traces_per_second)
    } elsif $sampling_type == 'probabilistic' {
      validate_numeric($probability)
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
