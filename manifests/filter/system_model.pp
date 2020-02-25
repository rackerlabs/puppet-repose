# == Resource: repose::filter::system_model
#
# This is a resource for generating system model configuration files
#
# === Parameters
#
# [*ensure*]
# Bool. Ensure config file is present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String. Config filename
# Defaults to <tt>system-model.cfg.xml</tt>
#
# [*app_name*]
# App name for the repose cluster id
# Defaults to <tt>repose</tt>
#
# [*nodes*]
# Array of nodes in the cluster
#
# [*filters*]
# hash of hashes that contain the name of the filter and any
# configuration items
# Example:
# {
#   10 => { name => 'content-normalization' },
#   20 => { name => 'client-auth', 'uri-regex' => '.*' },
# }
#
# [*services*]
# hash of hashes that contain the name of the service and any
# configuration items
# Example:
# {
#   10 => { name => 'dist-datastore' },
# }
#
# [*endpoints*]
# Array of hashes that contain the endpoints
# Example:
# [
#   {
#     'id'        => 'localhost,
#     'protocol'  => 'http',
#     'hostname'  => 'localhost',
#     'root-path' => '',
#     'port'      => 8080,
#     'default'   => true
#   },
# ]
#
# [*port*]
# Port the cluster runs on. If you want to disable set to <tt>false</tt>
# Defaults to <tt>$repose::port</tt>
#
# [*https_port*]
# Port the cluster runs on when ssl enabled
#
# [*service_cluster*]
# Hash with name and an array of nodes
# Example:
# {
#   name => 'service_cluster1',
#   nodes => [
#     'node1.domain',
#     'node2.domain',
#   ]
# }
#
# [*tracing_header*]
# Hash with key value pairs of options for tracing header configuration
# options found in the System Model documentation Here:
# https://repose.atlassian.net/wiki/spaces/REPOSE/pages/526529/System+model
# WARNING: This is a Repose version 8 and above feature only.
# Defaults to <tt>{}</tt> Empty hash
#
# [*repose9*]
# Boolean value which signals the system-model template to leave out the
# cluster element in support of Repose v.9 and above. This is a half-step
# measure before supporting the new way Repose handles clustering in the
# system-model config.
# Defaults to <tt>false</tt> False
#
# [*encoded_headers*]
# Array of header names that need to be encoded before being sent to the origin service.
#
# === Examples
#
# $app_name = 'repose'
# $app_nodes = [ 'test1.domain', 'test2.domain' ]
# $app_port = 9090
# $filters = {
#   10 => { name => 'content-normalization' },
#   20 => { name => 'http-logging', configuration => 'pre-ratelimit-httplog.cfg.xml' },
#   30 => { name => 'ip-identity' },
#   40 => { name => 'client-auth', uri-regex => '.*' },
#   50 => { name => 'rate-limiting' },
#   60 => { name => 'http-logging', configuration => 'http-logging.cfg.xml' },
#   70 => { name => 'compression' },
#   80 => { name => 'translation' },
#   90 => { name => 'api-validator' },
#   99 => { name => 'default-router' },
# }
# $services = {
#   10 => { name => 'dist-datastore' },
# }
# $endpoints = [
#   { id => 'localhost', protocol => 'http', hostname => 'localhost', root-path => "", port => 8080, 'default' => true },
# ]
# repose::filter::system_model {
#   'default':
#     app_name       => $app_name,
#     nodes          => $app_nodes,
#     port           => $app_port,
#     filters        => $filters,
#     services       => $services,
#     endpoints      => $endpoints,
#     tracing_header => { 'enabled' => 'true' },
# }
#
# === Authors
#
# * Josh Bell <mailto:josh.bell@rackspace.com>
# * Alex Schultz <mailto:alex.schultz@rackspace.com>
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
define repose::filter::system_model (
  $ensure              = present,
  $filename            = 'system-model.cfg.xml',
  $app_name            = 'repose',
  $nodes               = undef,
  $filters             = undef,
  $services            = undef,
  $endpoints           = undef,
  $port                = $repose::port,
  $https_port          = undef,
  $repose9             = false,
  $rewrite_host_header = undef,
  $service_cluster     = undef,
  $tracing_header      = {},
  $encoded_headers     = [],
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

## app_name
  if $app_name == undef {
    fail('app_name is a required parameter')
  }

## nodes
  if $nodes == undef {
    fail('nodes is a required parameter')
  }

## filters
  if $filters == undef {
    fail('filters is a required parameter. see documentation for details.')
  }

## endpoints
  if $endpoints == undef {
    fail('endpoints is a required parameter. see documentation for details.')
  }

## Manage actions

  file { "${repose::configdir}/${filename}":
    ensure  => $file_ensure,
    owner   => $repose::owner,
    group   => $repose::group,
    mode    => $repose::mode,
    require => Class['::repose::package'],
    content => template('repose/system-model.cfg.xml.erb')
  }

}
