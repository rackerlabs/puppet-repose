require 'spec_helper'
describe 'repose::filter::keystone_v2_basic_auth', type: :define do
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
        let(:params) do
          {
            ensure: 'absent',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/keystone-v2-basic-auth.cfg.xml').with_ensure(
            'absent',
          )
        }
      end

      context 'providing a filename' do
        let(:title) { 'validator' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'my-config.cfg.xml',
            identity_service_url: 'http://foo',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/my-config.cfg.xml')
        }
      end

      context 'setting the identity url' do
        let(:title) { 'validator' }
        let(:params) do
          {
            ensure: 'present',
            identity_service_url: 'http://foo',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/keystone-v2-basic-auth.cfg.xml').with_content(%r{keystone-v2-service-uri="http:\/\/foo"})
        }
      end

      context 'setting token cache' do
        let(:title) { 'validator' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'keystone-v2-basic-auth.cfg.xml',
            identity_service_url: 'http://foo',
            token_cache_timeout: '1000',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/keystone-v2-basic-auth.cfg.xml').with_content(%r{token-cache-timeout-millis="1000"})
        }
      end

      context 'setting connection pool id' do
        let(:title) { 'validator' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'keystone-v2-basic-auth.cfg.xml',
            identity_service_url: 'http://foo',
            connection_pool_id: 'bar',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/keystone-v2-basic-auth.cfg.xml').with_content(%r{connection-pool-id="bar"})
        }
      end

      context 'setting secret type' do
        let(:title) { 'validator' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'keystone-v2-basic-auth.cfg.xml',
            identity_service_url: 'http://foo',
            secret_type: 'password',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/keystone-v2-basic-auth.cfg.xml').with_content(%r{secret-type="password"})
        }
      end

      context 'setting secret type incorrectly' do
        let(:title) { 'validator' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'keystone-v2-basic-auth.cfg.xml',
            identity_service_url: 'http://foo',
            secret_type: 'banana',
          }
        end

        it {
          is_expected.to raise_error(Puppet::Error, %r{secret_type must have a value of api-key or password})
        }
      end

      context 'with delegating & delegating_quality' do
        let(:title) { 'default' }
        let(:params) do
          {
            identity_service_url: 'http://foo',
            delegating: true,
            delegating_quality: 0.7,
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/keystone-v2-basic-auth.cfg.xml')
            .with_content(%r{delegating quality="0.7"})
        }
      end
    end
  end
end
