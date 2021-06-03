# == Class: repose::filter
#
# This class should not be used.
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
  # merging same hash from multiple sources, innermost hash defs first
  $filters = lookup('repose::filter', { 'merge' => 'deep' })

  # these are classes so we'll instantiate classes
  $classes = ['atom_feed_service','container','http_connection_pool']
  $filters.each |$k,$v| {
    if $k in $classes {
      class { "repose::filter::${k}":
        * => $v
      }
    } else {
  # all the rest of the filters are defined_types with nested hashes, 
  # so we can run create_resources    
      create_resources("repose::filter::${k}", $v)
    }
  }
}
