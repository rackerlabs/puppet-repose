# == Class: repose::filter::http_connection_pool
#
# This is a resource for generating http connection pool configuration files
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
# [*default_is_default*]
# Boolean. Indicates to repose that this is the default connection pool
# to use for http requests.
# Defaults to <tt>true</tt>
#
# [*default_conn_manager_max_total*]
# Integer. Defines the maximum number of connections in total. This limit is
# interpreted by client connection managers and applies to individual manager
# instances.
# Defaults to <tt>10</tt>
#
# [*default_conn_manager_max_per_route*]
# Integer. Defines the maximum number of connections per route. This limit is
# interpreted by client connection managers and applies to individual manager
# instances.
# Defaults to <tt>2</tt>
#
# [*default_socket_timeout*]
# Integer. Sets the socket timeout (SO_TIMEOUT) in milliseconds to be used when
# executing the method. A timeout value of zero is interpreted as an infinite
# timeout.
# Defaults to <tt>30000</tt>
#
# [*default_socket_buffer_size*]
# Integer. Determines the size of the internal socket buffer used to buffer
# data while receiving / transmitting HTTP messages. This parameter expects a
# value of type java.lang.Integer. If this parameter is not set, HttpClient
# will allocate 8192 byte socket buffers.
# Defaults to <tt>8192</tt>
#
# [*default_conn_timeout*]
# Integer. Determines the timeout in milliseconds until a connection is
# established. A timeout value of zero is interpreted as an infinite timeout.
# This parameter expects a value of type java.lang.Integer. If this parameter
# is not set, connect operations will not time out (infinite timeout).
# Defaults to <tt>30000</tt>
#
# [*default_conn_max_line_length*]
# Integer. Determines the maximum line length limit. If set to a positive
# value, any HTTP line exceeding this limit will cause an java.io.IOException.
# A negative or zero value will effectively disable the check. This parameter
# expects a value of type java.lang.Integer. If this parameter is not set, no
# limit will be enforced.
# Defaults to <tt>8192</tt>
#
# [*default_conn_max_header_count*]
# Integer. Determines the maximum HTTP header count allowed. If set to a
# positive value, the number of HTTP headers received from the data stream
# exceeding this limit will cause an java.io.IOException. A negative or zero
# value will effectively disable the check. This parameter expects a value of
# type java.lang.Integer. If this parameter is not set, no limit will be
# enforced.
# Defaults to <tt>100</tt>
#
# [*default_conn_max_status_line_garbage*]
# Integer. Defines the maximum number of ignorable lines before we expect a
# HTTP response's status line. With HTTP/1.1 persistent connections, the
# problem arises that broken scripts could return a wrong Content-Length (there
# are more bytes sent than specified). Unfortunately, in some cases, this
# cannot be detected after the bad response, but only before the next one. So
# HttpClient must be able to skip those surplus lines this way. This parameter
# expects a value of type java.lang.Integer. 0 disallows all garbage/empty
# lines before the status line. Use java.lang.Integer#MAX_VALUE for unlimited
# number. If this parameter is not set, unlimited number will be assumed.
# Defaults to <tt>100</tt>
#
# [*default_tcp_nodelay*]
# Boolean. Determines whether Nagle's algorithm is to be used. Nagle's
# algorithm tries to conserve bandwidth by minimizing the number of segments
# that are sent. When applications wish to decrease network latency and
# increase performance, they can disable Nagle's algorithm (that is enable
# TCP_NODELAY. Data will be sent earlier, at the cost of an increase in
# bandwidth consumption. This parameter expects a value of type
# java.lang.Boolean. If this parameter is not set, TCP_NODELAY will be enabled
# (no delay).
# Defaults to <tt>true</tt>
#
# [*default_keepalive_timeout*]
# Integer. Some HTTP servers use a non-standard Keep-Alive header to
# communicate to the client the period of time in seconds they intend to keep
# the connection alive on the server side. If this header is present in the
# response, the value in this header will be used to determine the maximum
# length of time to keep a persistent connection open. If the Keep-Alive header
# is NOT present in the response, the value of keepalive.timeout is evaluated.
# If this value is 0, the connection will be kept alive indefinitely. If the
# value is greater than 0, the connection will be kept alive for the number of
# milliseconds specified.
# Defaults to <tt>0</tt>
#
# [*additional_pools*]
# Array of Hashes containing pool configuration items. Hash keys are the same
# as the "default_*" variables with "default_" removed. In addition there is an
# id hash key that must be provided as well. The id must be unique and a pool
# with the id of "default" is already configured using the "default_*" vars.
# Defaults to <tt>undef</tt>
#
# === Links
#
# * https://repose.atlassian.net/wiki/display/REPOSE/Http+Connection+Pool+Service
#
# === Examples
#
# class repose::filter::http_connection_pool {
#   additional_pools                 => [
#     { id                           => 'client-auth-pool',
#       is_default                   => false,
#       conn_manager_max_total       => 200,
#       conn_manager_max_per_route   => 100,
#       socket_timeout               => 30000,
#       socket_buffer_size           => 8192,
#       conn_timeout                 => 30000,
#       conn_max_line_length         => 8192,
#       conn_max_header_count        => 100,
#       conn_max_status_line_garbage => 100,
#       tcp_nodelay                  => true,
#       keepalive_timeout            => 10000,
#     },
#   ]
# }
#
# === Authors
#
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
class repose::filter::http_connection_pool (
  $ensure                               = present,
  $filename                             = 'http-connection-pool.cfg.xml',
  $default_is_default                   = true,
  $default_conn_manager_max_total       = 200,
  $default_conn_manager_max_per_route   = 20,
  $default_socket_timeout               = 30000,
  $default_socket_buffer_size           = 8192,
  $default_conn_timeout                 = 30000,
  $default_conn_max_line_length         = 8192,
  $default_conn_max_header_count        = 100,
  $default_conn_max_status_line_garbage = 100,
  $default_tcp_nodelay                  = true,
  $default_keepalive_timeout            = 0,
  $additional_pools                     = undef,
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

## validate input
  validate_bool($default_is_default)
  validate_bool($default_tcp_nodelay)
  if ($additional_pools != undef) {
    validate_array($additional_pools)
  }

## Manage actions

  file { "${repose::params::configdir}/${filename}":
    ensure  => $file_ensure,
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Package['repose-filters'],
    content => template('repose/http-connection-pool.cfg.xml.erb'),
  }

}
