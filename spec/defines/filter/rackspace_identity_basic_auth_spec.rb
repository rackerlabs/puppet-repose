require 'spec_helper'
describe 'repose::filter::rackspace_identity_basic_auth', type: :define do
  let :pre_condition do
    'include repose'
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end

      context 'default parameters' do
        let(:title) { 'default' }

        it {
          is_expected.to contain_file('/etc/repose/rackspace-identity-basic-auth.cfg.xml').with_content(
            %r{rackspace-identity-service-uri="https:\/\/identity.api.rackspacecloud.com\/v2.0\/tokens"},
          ).with_content(
            %r{token-cache-timeout-millis="600000"},
          )
        }
      end

      context 'with ensure absent' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'absent',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/rackspace-identity-basic-auth.cfg.xml').with_ensure(
            'absent',
          )
        }
      end
      context 'providing a validator' do
        let(:title) { 'validator' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'my-config.cfg.xml',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/my-config.cfg.xml')
        }
      end

      context 'lowering token cache' do
        let(:title) { 'validator' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'rackspace-identity-basic-auth.cfg.xml',
            token_cache_timeout: '1000',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/rackspace-identity-basic-auth.cfg.xml').with_content(%r{token-cache-timeout-millis="1000"})
        }
      end

      context 'with delegating & delegating_quality' do
        let(:title) { 'default' }
        let(:params) do
          {
            delegating: true,
            delegating_quality: '0.7',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/rackspace-identity-basic-auth.cfg.xml')
            .with_content(%r{delegating quality="0.7"})
        }
      end
    end
  end
end
