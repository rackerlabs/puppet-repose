require 'spec_helper'
describe 'repose::filter::keystone_v2_basic_auth', :type => :define do
  let :pre_condition do
    'include repose'
  end
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end


      context 'with ensure absent' do
        let(:title) { 'default' }
        let(:params) { {
          :ensure => 'absent'
        } }
        it {
          should contain_file('/etc/repose/keystone-v2-basic-auth.cfg.xml').with_ensure(
            'absent')
        }
      end

      context 'providing a filename' do
        let(:title) { 'validator' }
        let(:params) { {
          :ensure               => 'present',
          :filename             => 'my-config.cfg.xml',
          :identity_service_url => 'http://foo'
        } }
        it {
          should contain_file('/etc/repose/my-config.cfg.xml')
        }
      end

      context 'setting the identity url' do
        let(:title) { 'validator' }
        let(:params) { {
            :ensure               => 'present',
            :identity_service_url => 'http://foo',
        } }
        it {
          should contain_file('/etc/repose/keystone-v2-basic-auth.cfg.xml').with_content(/keystone-v2-service-uri="http:\/\/foo"/)
        }
      end

      context 'setting token cache' do
        let(:title) { 'validator' }
        let(:params) { {
          :ensure               => 'present',
          :filename             => 'keystone-v2-basic-auth.cfg.xml',
          :identity_service_url => 'http://foo',
          :token_cache_timeout  => '1000'
        } }
        it {
          should contain_file('/etc/repose/keystone-v2-basic-auth.cfg.xml').with_content(/token-cache-timeout-millis="1000"/)
        }
      end

      context 'setting connection pool id' do
        let(:title) { 'validator' }
        let(:params) { {
            :ensure               => 'present',
            :filename             => 'keystone-v2-basic-auth.cfg.xml',
            :identity_service_url => 'http://foo',
            :connection_pool_id   => 'bar'
        } }
        it {
          should contain_file('/etc/repose/keystone-v2-basic-auth.cfg.xml').with_content(/connection-pool-id="bar"/)
        }
      end

      context 'setting secret type' do
        let(:title) { 'validator' }
        let(:params) { {
            :ensure               => 'present',
            :filename             => 'keystone-v2-basic-auth.cfg.xml',
            :identity_service_url => 'http://foo',
            :secret_type         => 'password'
        } }
        it {
          should contain_file('/etc/repose/keystone-v2-basic-auth.cfg.xml').with_content(/secret-type="password"/)
        }
      end

      context 'setting secret type incorrectly' do
        let(:title) { 'validator' }
        let(:params) { {
            :ensure               => 'present',
            :filename             => 'keystone-v2-basic-auth.cfg.xml',
            :identity_service_url => 'http://foo',
            :secret_type         => 'banana'
        } }
        it {
          should raise_error(Puppet::Error, /secret_type must have a value of api-key or password/)
        }
      end

      context 'with delegating & delegating_quality' do
        let(:title) { 'default' }
        let(:params) { {
          :identity_service_url => 'http://foo',
          :delegating         => true,
          :delegating_quality => '0.7'
        } }
        it {
          should contain_file('/etc/repose/keystone-v2-basic-auth.cfg.xml').
            with_content(/delegating quality="0.7"/)
        }
      end
    end
  end
end