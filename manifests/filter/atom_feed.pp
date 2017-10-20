# == Resource: repose::filter::atom_feed
#
# This is a resource for generating atom feeds entries for use with the atom feed service.
# Meant to be used with atom_feed_service
#
# === Parameters
#
# [*feed_id*]
# String. The id for this feed that will be used to tie it into other configurations.
# Defaults to the <tt>title</tt>
#
# [*feed_url*]
# String. The url for the feed. Required.
# Defaults to <tt>undef</tt>
#
# [*connection_pool_id*]
# String. The id of the connection pool to use. Optional.
# Defaults to <tt>undef</tt>.
# Repose will default to the default pool in the connection pool service.
#
# [*entry_order*]
# String. The order entries should be consumed in. Optional.
# Values are read and reverse-read.
# Read indicates that they will be from the head of the feed to prior high water mark.
# Reverse-read indicates that they will be processed based on punlish order.
# Defaults to <tt>undef</tt>.
# repose will default to read.
#
# [*auth_uri*]
# String. If this is an authenticated feed the uri to get keystone token from. Optional.
# Use also requires auth_username and auth_password.
# Defaults to <tt>undef</tt>
#
# [*auth_username*]
# String. The username to try to get a keystone token with. Optional.
# Default is <tt>undef</tt>
#
# [*auth_password*]
# String. The password to try to get a keystone token with. Optional.
# Default is <tt>undef</tt>
#
# [*auth_timeout*]
# String. The amount of time to attempt to authenticate before failing in milliseconds. Optional.
# Default is <tt>undef</tt>.
# Repose will default to 5000
#
# === Links
#
# * http://www.openrepose.org/versions/latest/services/atom-feed-consumption.html
#
# === Examples
#
# repose::filter::atom_feed { 'some-feed-id':
#   feed_uri => 'http://foo.com/feed',
# }
#
# === Authors
#
# * Adrian George <mailto:adrian.george@rackspace.com>
#
define repose::filter::atom_feed (
  $feed_id = $title,
  $feed_uri = undef,
  $connection_pool_id = undef,
  $entry_order = undef,
  $auth_uri = undef,
  $auth_username = undef,
  $auth_password = undef,
  $auth_timeout = undef,
) {

  if $feed_uri == undef {
    fail("feed_uri is required")
  }

  if ($entry_order != undef) and ! ($entry_order in [ read, reverse-read ]) {
    fail("\"${entry_order}\" is not a valid entry_order parameter value")
  }

  if (($auth_uri != undef) or ($auth_username != undef) or ($auth_password != undef)) and
     (($auth_uri == undef) or ($auth_username == undef) or ($auth_password == undef)) {
    fail("If used auth_uri, auth_username, and auth_password are all required")
  }

  concat::fragment { "feed-$title":
    target => "${repose::params::configdir}/atom-feed-service.cfg.xml",
    source => "puppet:///modules/${module_name}/atom-feed-fragment",
    order   => '50',
  }

}
