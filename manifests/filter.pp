# == Class: repose::filter
#
# This class passes hash data to filter classes and defined types.
#
# === Parameters
#
# None.
#
# === Examples
#
# None.
#
# === Authors
#
# * Greg Swift <mailto:greg.swift@rackspace.com>
# * c/o Cloud Integration Ops <mailto:cit-ops@rackspace.com>
#
class repose::filter {
  assert_private()
  # merging same hash from multiple sources, innermost hash defs first
  $filters = lookup('repose::filter', { 'merge' => 'deep' })

  # these are classes so we'll declare classes
  $classes = ['atom_feed_service','container','http_connection_pool']
  $filters.each |$k,$v| {
    if $k in $classes {
      class { "repose::filter::${k}":
        *      => $v,
        notify => "Service[${repose::service_name}]",
      }
    } else {
# all the rest of the filters are defined_types with nested hashes, 
# so we can run create_resources
      $defaults = {
        'notify' => "Service[${repose::service_name}]",
      }
      create_resources("repose::filter::${k}", $v, $defaults)
    }
  }
}
