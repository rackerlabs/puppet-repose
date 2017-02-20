# == Resource: repose::filter::saml_policy
#
# This is a resource for generating uri identity filter config files
#
# === Parameters
#
# [*ensure*]
# Bool.  Ensure config file present/absent
# Defaults to <tt>present</tt>
#
# [*filename*]
# String.  Config filename
# Defaults to <tt>saml-policy.cfg.xml</tt>
#
# [*policy_bypass_issuers*]
# Array, Optional Array of uri's of issuers. 
# Defaults to <tt>[]</tt>
#
# [*keystone_uri*]
# String, URI of the Keystone instance to use for authentication
# Defaults to <tt></tt>
#
# [*keystone_user*]
# String, username of the user to authenticate against the keystone_uri for
# policy acquisition
# Defaults to <tt></tt>
#
# [*keystone_password*]
# String, password of the user to authenticate against the keystone_uri for
# policy acquisition
# Defaults to <tt></tt>
#
# [*keystone_pool*]
# String, name of the pool in http_connection_pool.cfg.xml to use for making
# requests. Optional, will use default pool if unspecified.
# Defaults to <tt>undef</tt>
#
# [*policy_uri*]
# String, URI to use for policy acquisition 
# Defaults to <tt></tt>
#
# [*policy_pool*]
# String, name of the pool in http_connection_pool.cfg.xml to use for policy
# requests. Optional, will use default pool if unspecified.
# Defaults to <tt>undef</tt>
#
# [*policy_cache_ttl*]
# Int, Positive integer in seconds for policies time to live in the proxy cache
# Defaults to <tt>300</tt>
#
# [*policy_cache_feed_id*]
# String, The atom feed id of an atom feed that contains policy events to be
# used for cache evictions. Policies will be evicted from the cache for all
# three event types (i.e. CREATE, UPDATE, DELETE). This is optional, if
# unused cache eviction will be purely off ttl.
# Defaults to <tt>undef</tt>
#
# [*signature_keystore_path*]
# String, The path to the keystore on the file system that contains the
# certificates for signing the SAML response.
# Defaults to <tt>/etc/pki/java/repose-saml-policy.ks</tt>
#
# [*signature_keystore_password*]
# String, The password for using the keystore, defined in
# `signature_keystore_path`
# Defaults to <tt></tt>
#
# [*signature_keystore_certname*]
# String, The name the certificate is in the keystore.
# Defaults to <tt></tt>
#
# [*signature_keystore_keypass*]
# String, The password for the certificate in the keystore.
# Defaults to <tt></tt>
#
# [*signature_keystore_pem*]
# String, PEM format certificate. 
# Defaults to <tt></tt>
#
#
# === Links
#
# * http://www.openrepose.org/versions/8.4.0.1/filters/saml-policy.html
#
# === Examples
#
# repose::filter::saml_policy {
#   'default':
#     policy_bypass_issuers       => [],
#     keystone_uri                => 'http://keystone.somewhere.com',
#     keystone_user               => 'aUsername',
#     keystone_password           => 'somePassword',
#     keystone_pool               => 'pool1',
#     policy_uri                  => 'http://keystone.somewhere.com',
#     policy_pool                 => 'pool2',
#     policy_cache_ttl            => 300,
#     policy_cache_feed_id        => 'identity-policy',
#     signature_keystore_path     => '/etc/pki/java/repose-saml-policy.ks',
#     signature_keystore_password => 'banana',
#     signature_keystore_certname  => 'thingy',
#     signature_keystore_keypass  => 'phone',
#     signature_keystore_pem      => 'PEM_FORMAT_CERT_HERE',
# }
#
# === Authors
#
# * Josh Bell <nailto:josh.bell@rackspace.com>
# * c/o Cloud Identity Ops <mailto:identityops@rackspace.com>
#
define repose::filter::saml_policy (
  $keystone_uri,
  $keystone_user,
  $keystone_password,
  $signature_keystore_certname,
  $signature_keystore_keypass,
  $signature_keystore_password,
  $signature_keystore_pem,
  $policy_uri,
  $keystone_pool               = undef,
  $ensure                      = present,
  $filename                    = 'saml-policy.cfg.xml',
  $policy_bypass_issuers       = [],
  $policy_cache_feed_id        = undef,
  $policy_cache_ttl            = 300,
  $policy_pool                 = undef,
  $signature_keystore_path     = '/etc/pki/java/repose-saml-policy.ks',
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
    $content_template = template("${module_name}/saml-policy.cfg.xml.erb")
  } else {
    $content_template = undef
  }

## Manage actions
  # Lay Down PEM cert on disk for java_ks to work with. 
  file { "${repose::params::configdir}/signature_keys.pem":
    ensure  => $file_ensure,
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Class['::repose::package'],
    content => $signature_keystore_pem,
  }

  java_ks { 'saml_policy_keystore':
    ensure       => $ensure,
    certificate  => "${repose::params::configdir}/signature_keys.pem",
    private_key  => "${repose::params::configdir}/signature_keys.pem",
    destkeypass  => "${signature_keystore_keypass}",
    target       => "${signature_keystore_path}",
    password     => "${signature_keystore_password}",
    name         => "${signature_keystore_certname}",
    require      => File["${repose::params::configdir}/signature_keys.pem"],
  }

  file { "${repose::params::configdir}/${filename}":
    ensure  => $file_ensure,
    owner   => $repose::params::owner,
    group   => $repose::params::group,
    mode    => $repose::params::mode,
    require => Class['::repose::package'],
    content => $content_template
  }

}
