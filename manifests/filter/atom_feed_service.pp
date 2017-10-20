# == Resource: repose::filter::atom_feed_service
#
# This is a resource for generating the configuration for the atom feed service in repose.
# It's expected to be used in conjunction with repose::filter::atom_feed to define the feeds that one want's to subscribe to.
#
# === Parameters
#
# [*ensure*]
# String. Determines whether the configuration file should be available. Required.
# Values are present and absent
# Defaults to the <tt>present</tt>
#
# === Links
#
# * http://www.openrepose.org/versions/latest/services/atom-feed-consumption.html
#
# === Examples
#
# class { 'repose::filter::atom_feed_service':
#   ensure => 'present',
# }
#
# repose::filter::atom_feed { 'some-feed-id':
#   feed_uri => 'http://foo.com/feed',
# }
#
# repose::filter::atom_feed { 'some-other-feed-id':
#   feed_uri => 'http://bar.com/feed',
# }
#
# === Authors
#
# * Adrian George <mailto:adrian.george@rackspace.com>
#
class repose::filter::atom_feed_service (
  $ensure = present,
) {

  ## ensure
  if ! ($ensure in [ present, absent ]) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
  }

  if $::debug {
    debug("\$ensure = '${ensure}'")
  }

  concat { "${repose::params::configdir}/atom-feed-service.cfg.xml":
    ensure => $ensure,
  }

  concat::fragment { 'header':
    target => "${repose::params::configdir}/atom-feed-service.cfg.xml",
    source => "puppet:///modules/${module_name}/atom-feed-service-header",
    order  => '01',
  }

  concat::fragment { 'footer':
    target => "${repose::params::configdir}/atom-feed-service.cfg.xml",
    source => "puppet:///modules/${module_name}/atom-feed-service-footer",
    order  => '99',
  }
}
