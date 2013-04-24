# == Class: MODULE::config
#
# FIXME/TODO Please check if you want to remove this class because it may be
# unnecessary for your module. Don't forget to update the class
# declarations and relationships at init.pp afterwards (the relevant
# parts are marked with "FIXME/TODO" comments).
#
# This class exists to coordinate all LOCAL configuration related actions,
# functionality and logical units in a central place.  It is the only
# manifest file you should be editing manually.
#
# The primary use is to override variable assignments in MODULE::params. The
# only variables that this overrides are those included here already.
#
# All variables here should be set to undef unless in use.
#
# Further information is available in MODULE and MODULE::params classes
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.  It should only really be used by
# the MODULE::params class.
#
#
# [ NO empty lines allowed between this and definition below for rdoc ]
class MODULE::config {

# content
  $content = undef

}
