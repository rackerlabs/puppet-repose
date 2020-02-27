# == Class: repose::logroate
#
# This class is used ot manage the repose log rotate configuration.
#
# === Parameters
#
# [*log_files*]
# Array. This is an array of fully qualified paths to the log files we need to
# rotate.
# Defaults to <tt>[ '/var/log/repose.log' ]</tt>
#
# [*rotate_frequency*]
# String. This is the frequency we want to rotate. Should be daily, weekly, monthly, yearly
# Defaults to <tt>daily</tt>
#
# [*rotate_count*]
# Integer. Number of times to rotate before removing log files.
# Defaults to <tt>4</tt>
#
# [*compress*]
# Bool. Setting to compress log files
# Defaults to <tt>true</tt>
#
# [*delay_compress*]
# Bool. Setting to delay compression until the next rotation
# Defaults to <tt>true</tt>
#
# [*use_date_ext*]
# Bool. Setting to use the date extension when rotating
# Defaults to <tt>true</tt>
#
# === Examples
#
# class { 'repose::logrotate': 
#   log_files => [
#     '/var/log/repose/repose.log',
#     '/var/log/repose/credentials.log',
#     '/var/log/repose/http_repose.log',
#     '/var/log/repose/pre-ratelimit-http.log',
#   ]
# }
#
# === Authors
#
# * Alex Schultz <alex.schultz@rackspace.com>
# * C/O CIT-Ops <cit-ops@rackspace.com>
#
class repose::logrotate (
  Array $log_files         = [ '/var/log/repose/repose.log', ],
  String $rotate_frequency = 'daily',
  Integer $rotate_count     = 4,
  Boolean $compress        = true,
  Boolean $delay_compress  = true,
  Boolean $use_date_ext    = true,
) {
  if ! ($rotate_frequency in [ 'daily', 'weekly', 'montly', 'yearly' ]) {
    fail("${rotate_frequency} is not a valid rotate_frequency")
  }

  $file_ensure = $repose::ensure ? {
    absent  => absent,
    default => file,
  }

  file { '/etc/logrotate.d/repose':
    ensure  => $file_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/logrotate.erb")
  }
}
