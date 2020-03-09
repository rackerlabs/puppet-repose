require 'spec_helper'
describe 'repose::filter::saml_policy', :type => :define do
  let :pre_condition do
    'include repose'
  end
  params = {
    :ensure                      => 'present',
    :filename                    => 'saml-policy.cfg.xml',
    :keystone_uri                => 'http://keystone.somewhere.com',
    :keystone_user               => 'aUsername',
    :keystone_password           => 'somePassword',
    :signature_keystore_certname => 'keycertname',
    :signature_keystore_keypass  => 'keyPassword',
    :signature_keystore_password => 'keystorePassword',
    :signature_keystore_pem      => "-----BEGIN CERTIFICATE-----\n
MIIEczCCA1ugAwIBAgIBADANBgkqhkiG9w0BAQQFAD..AkGA1UEBhMCR0Ix\n
EzARBgNVBAgTClNvbWUtU3RhdGUxFDASBgNVBAoTC0..0EgTHRkMTcwNQYD\n
VQQLEy5DbGFzcyAxIFB1YmxpYyBQcmltYXJ5IENlcn..XRpb24gQXV0aG9y\n
aXR5MRQwEgYDVQQDEwtCZXN0IENBIEx0ZDAeFw0wMD..TUwMTZaFw0wMTAy\n
MDQxOTUwMTZaMIGHMQswCQYDVQQGEwJHQjETMBEGA1..29tZS1TdGF0ZTEU\n
MBIGA1UEChMLQmVzdCBDQSBMdGQxNzA1BgNVBAsTLk..DEgUHVibGljIFBy\n
aW1hcnkgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxFD..AMTC0Jlc3QgQ0Eg\n
THRkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCg..Tz2mr7SZiAMfQyu\n
vBjM9OiJjRazXBZ1BjP5CE/Wm/Rr500PRK+Lh9x5eJ../ANBE0sTK0ZsDGM\n
ak2m1g7oruI3dY3VHqIxFTz0Ta1d+NAjwnLe4nOb7/..k05ShhBrJGBKKxb\n
8n104o/5p8HAsZPdzbFMIyNjJzBM2o5y5A13wiLitE..fyYkQzaxCw0Awzl\n
kVHiIyCuaF4wj571pSzkv6sv+4IDMbT/XpCo8L6wTa..sh+etLD6FtTjYbb\n
rvZ8RQM1tlKdoMHg2qxraAV++HNBYmNWs0duEdjUbJ..XI9TtnS4o1Ckj7P\n
OfljiQIDAQABo4HnMIHkMB0GA1UdDgQWBBQ8urMCRL..5AkIp9NJHJw5TCB\n
tAYDVR0jBIGsMIGpgBQ8urMCRLYYMHUKU5AkIp9NJH..aSBijCBhzELMAkG\n
A1UEBhMCR0IxEzARBgNVBAgTClNvbWUtU3RhdGUxFD..AoTC0Jlc3QgQ0Eg\n
THRkMTcwNQYDVQQLEy5DbGFzcyAxIFB1YmxpYyBQcm..ENlcnRpZmljYXRp\n
b24gQXV0aG9yaXR5MRQwEgYDVQQDEwtCZXN0IENBIE..DAMBgNVHRMEBTAD\n
AQH/MA0GCSqGSIb3DQEBBAUAA4IBAQC1uYBcsSncwA..DCsQer772C2ucpX\n
xQUE/C0pWWm6gDkwd5D0DSMDJRqV/weoZ4wC6B73f5..bLhGYHaXJeSD6Kr\n
XcoOwLdSaGmJYslLKZB3ZIDEp0wYTGhgteb6JFiTtn..sf2xdrYfPCiIB7g\n
BMAV7Gzdc4VspS6ljrAhbiiawdBiQlQmsBeFz9JkF4..b3l8BoGN+qMa56Y\n
It8una2gY4l2O//on88r5IWJlm1L0oA8e4fR2yrBHX..adsGeFKkyNrwGi/\n
7vQMfXdGsRrXNGRGnX+vWDZ3/zWI0joDtCkNnqEpVn..HoX\n 
-----END CERTIFICATE-----",
    :policy_uri                  => 'http://keystone.somewhere.com/puppet',
  }
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end

      context 'default + sample required parameters' do
        let(:title) { 'default' }
        let (:params) { params }
        it {
          should contain_file('/etc/repose/saml-policy.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/<keystone-credentials uri="http:\/\/keystone.somewhere.com"/).
            with_content(/username="aUsername"/).
            with_content(/password="somePassword"\/>/).
            with_content(/<policy-endpoint uri="http:\/\/keystone.somewhere.com\/puppet"/). 
            with_content(/<cache ttl="300"/).
            with_content(/<signature-credentials keystore-filename="\/etc\/pki\/java\/repose-saml-policy.ks"/).
            with_content(/keystore-password="keystorePassword"/). 
            with_content(/key-name="keycertname"/).
            with_content(/key-password="keyPassword"/) 
          should contain_file('/etc/repose/signature_keys.pem').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/-----BEGIN CERTIFICATE-----/).
            with_content(/-----END CERTIFICATE-----/)
          is_expected.to contain_java_ks('saml_policy_keystore')
        }
      end

      context 'with ensure absent' do
        let(:title) { 'default' }
        let (:params) { 
          params.merge({ 
            :ensure           => 'absent',
          })
        }
        it {
          should contain_file('/etc/repose/saml-policy.cfg.xml').with_ensure(
            'absent')
          should contain_file('/etc/repose/signature_keys.pem').with_ensure(
            'absent')
          is_expected.to contain_java_ks('saml_policy_keystore').with_ensure(
            'absent')
        }
      end

      context 'providing a cache ttl' do
        let(:title) { 'user_provided_cache' }
        let (:params) { 
          params.merge({ 
            :policy_cache_ttl => 500,
          })
        }
        it {
          should contain_file('/etc/repose/saml-policy.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/<cache ttl="500"/)
        }
      end

      context 'providing user defined keystone pool' do
        let(:title) { 'user_provided_keystone_pool' }
        let (:params) { 
          params.merge({ 
            :keystone_pool => 'keystone_pool',
          })
        }
        it {
          should contain_file('/etc/repose/saml-policy.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/connection-pool-id="keystone_pool"/)
        }
      end

      context 'providing user defined policy pool' do
        let(:title) { 'user_provided_policy_pool' }
        let (:params) { 
          params.merge({ 
            :policy_pool   => 'policy_pool',
          })
        }
        it {
          should contain_file('/etc/repose/saml-policy.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/connection-pool-id="policy_pool"/)
        }
      end

      context 'providing user defined keystore path' do
        let(:title) { 'user_provided_keystore_path' }
        let (:params) { 
          params.merge({ 
            :signature_keystore_path => '/etc/pki/java/keystore.ks',
          })
        }
        it {
          should contain_file('/etc/repose/saml-policy.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/<signature-credentials keystore-filename="\/etc\/pki\/java\/keystore.ks"/)
        }
      end

      context 'providing bypass issuers' do
        let(:title) { 'user_provided_bypass_issures' }
        let (:params) { 
          params.merge({ 
            :policy_bypass_issuers => [ 'http://www.issuer1.com',
                                      'http://www.issuer2.com',
                                    ],
          })
        }
        it {
          should contain_file('/etc/repose/saml-policy.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/<policy-bypass-issuers>/).
            with_content(/<issuer>http:\/\/www.issuer1.com<\/issuer>/).
            with_content(/<issuer>http:\/\/www.issuer2.com<\/issuer>/).
            with_content(/<\/policy-bypass-issuers>/)
        }
      end

      context 'providing a atom feed id' do
        let(:title) { 'user_provided_bypass_issures' }
        let (:params) { 
          params.merge({ 
            :policy_cache_feed_id  => 'feed_id',
          })
        }
        it {
          should contain_file('/etc/repose/saml-policy.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/atom-feed-id="feed_id"/)
        }
      end
    end
  end
end