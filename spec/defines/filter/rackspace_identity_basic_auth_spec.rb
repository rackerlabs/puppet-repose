require 'spec_helper'
describe 'repose::filter::rackspace_identity_basic_auth', :type => :define do
  let :pre_condition do
    'include repose'
  end
  context 'on RedHat' do
    let :facts do
    {
      :osfamily               => 'RedHat',
      :operationsystemrelease => '6',
    }
    end


    context 'default parameters' do
      let(:title) { 'default' }
      it {
        should contain_file('/etc/repose/rackspace-identity-basic-auth.cfg.xml').with_content(
          /rackspace-identity-service-uri="https:\/\/identity.api.rackspacecloud.com\/v2.0\/tokens"/).with_content(
          /token-cache-timeout-millis="600000"/)
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
      } }
      it {
        should contain_file('/etc/repose/rackspace-identity-basic-auth.cfg.xml').with_ensure(
          'absent')
      }
    end
    context 'providing a validator' do
      let(:title) { 'validator' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'my-config.cfg.xml',
      } }
      it {
        should contain_file('/etc/repose/my-config.cfg.xml')
      }
    end

    context 'lowering token cache' do
      let(:title) { 'validator' }
      let(:params) { {
        :ensure              => 'present',
        :filename            => 'rackspace-identity-basic-auth.cfg.xml',
        :token_cache_timeout => '1000'
      } }
      it {
        should contain_file('/etc/repose/rackspace-identity-basic-auth.cfg.xml').with_content(/token-cache-timeout-millis="1000"/)
      }
    end

    context 'with defaults with old namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => false }"
      end

      let(:title) { 'default' }
      it {
        should contain_file('/etc/repose/rackspace-identity-basic-auth.cfg.xml').
          with_content(/docs.rackspacecloud.com/)
      }
    end

    context 'with defaults with new namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => true }"
      end

      let(:title) { 'default' }
      it {
        should contain_file('/etc/repose/rackspace-identity-basic-auth.cfg.xml').
          with_content(/docs.openrepose.org/)
      }
    end

    context 'with delegating & delegating_quality' do
      let(:title) { 'default' }
      let(:params) { {
        :delegating         => true,
        :delegating_quality => '0.7'
      } }
      it {
        should contain_file('/etc/repose/rackspace-identity-basic-auth.cfg.xml').
          with_content(/delegating quality="0.7"/)
      }
    end

  end
end
