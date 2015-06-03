require 'spec_helper'
describe 'repose::filter::client_auth_n', :type => :define do
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
        expect {
          should compile
        }.to raise_error(Puppet::Error, /auth is a required parameter/)
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
      } }
      it {
        should contain_file('/etc/repose/client-auth-n.cfg.xml').with_ensure(
          'absent')
      }
    end

    context 'providing a auth settings' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'client-auth-n.cfg.xml',
        :auth       => {
          'user' => 'username',
          'pass' => 'password',
          'uri'  => 'http://uri'
        },
        :client_maps => [ 'testing', ],
      } }
      it {
        should contain_file('/etc/repose/client-auth-n.cfg.xml').with(
          :ensure => 'file',
          :owner => 'repose',
          :group => 'repose'
        )
        should contain_file('/etc/repose/client-auth-n.cfg.xml').
          with_content(/identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"/).
          with_content(/client-mapping id-regex=\"testing\"/).
          with_content(/delegable=\"false\"/).
          without_content(/delegating/).
          with_content(/tenanted=\"false\"/).
          with_content(/group-cache-timeout=\"60000\"/).
          without_content(/connectionPoolId/).
          without_content(/token-cache-timeout/)
      }
    end

    context 'providing token_cache_timeout' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure              => 'present',
        :filename            => 'client-auth-n.cfg.xml',
        :auth                => {
          'user' => 'username',
          'pass' => 'password',
          'uri'  => 'http://uri'
        },
        :token_cache_timeout => '600000',
      } }
      it {
        should contain_file('/etc/repose/client-auth-n.cfg.xml').with(
          :ensure => 'file',
          :owner => 'repose',
          :group => 'repose'
        )
        should contain_file('/etc/repose/client-auth-n.cfg.xml').
          with_content(/identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"/).
          with_content(/token-cache-timeout=\"600000\"/)
      }
    end

    context 'providing connection_pool_id' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure              => 'present',
        :filename            => 'client-auth-n.cfg.xml',
        :auth                => {
          'user' => 'username',
          'pass' => 'password',
          'uri'  => 'http://uri'
        },
        :connection_pool_id => 'my-connection-pool',
      } }
      it {
        should contain_file('/etc/repose/client-auth-n.cfg.xml').with(
          :ensure => 'file',
          :owner => 'repose',
          :group => 'repose'
        )
        should contain_file('/etc/repose/client-auth-n.cfg.xml').
          with_content(/identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"/).
          with_content(/connectionPoolId=\"my-connection-pool\"/)
      }
    end

    context 'providing ignore_tenant_roles' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure              => 'present',
        :filename            => 'client-auth-n.cfg.xml',
        :auth                => {
          'user' => 'username',
          'pass' => 'password',
          'uri'  => 'http://uri'
        },
        :ignore_tenant_roles => [ 'role' ],
      } }
      it {
        should contain_file('/etc/repose/client-auth-n.cfg.xml').with(
          :ensure => 'file',
          :owner => 'repose',
          :group => 'repose'
        )
        should contain_file('/etc/repose/client-auth-n.cfg.xml').
          with_content(/identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"/).
          with_content(/ignore-tenant-roles/).
          with_content(/<role>role<\/role>/)
      }
    end

    context 'do not provide send_all_tenant_ids' do
      let(:title) { 'default' }
      let(:params) { {
          :ensure              => 'present',
          :filename            => 'client-auth-n.cfg.xml',
          :auth                => {
              'user' => 'username',
              'pass' => 'password',
              'uri'  => 'http://uri'
          },
      } }
      it {
        should contain_file('/etc/repose/client-auth-n.cfg.xml').with(
                   :ensure => 'file',
                   :owner => 'repose',
                   :group => 'repose'
               )
        should contain_file('/etc/repose/client-auth-n.cfg.xml').
                   with_content(/identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"/).
                   without_content(/send-all-tenant-ids/)
      }
    end

    context 'providing send_all_tenant_ids' do
      let(:title) { 'default' }
      let(:params) { {
          :ensure              => 'present',
          :filename            => 'client-auth-n.cfg.xml',
          :auth                => {
              'user' => 'username',
              'pass' => 'password',
              'uri'  => 'http://uri'
          },
          :send_all_tenant_ids => true,
      } }
      it {
        should contain_file('/etc/repose/client-auth-n.cfg.xml').with(
                   :ensure => 'file',
                   :owner => 'repose',
                   :group => 'repose'
               )
        should contain_file('/etc/repose/client-auth-n.cfg.xml').
                   with_content(/identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"/).
                   with_content(/send-all-tenant-ids=\"true\"/)
      }
    end

    context 'providing delegating for repose 7+' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'client-auth-n.cfg.xml',
        :auth       => {
          'user' => 'username',
          'pass' => 'password',
          'uri'  => 'http://uri'
        },
        :client_maps => [ 'testing', ],
        :delegating  => 'true'
      } }
      it {
        should contain_file('/etc/repose/client-auth-n.cfg.xml').with(
          :ensure => 'file',
          :owner => 'repose',
          :group => 'repose'
        )
        should contain_file('/etc/repose/client-auth-n.cfg.xml').
          with_content(/identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"/).
          with_content(/client-mapping id-regex=\"testing\"/).
          without_content(/delegable=/).
          with_content(/delegating quality=\"0\.5\"/).
          with_content(/tenanted=\"false\"/).
          with_content(/group-cache-timeout=\"60000\"/).
          without_content(/connectionPoolId/).
          without_content(/token-cache-timeout/)
      }
    end

    context 'with defaults with old namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => false }"
      end

      let(:title) { 'default' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'client-auth-n.cfg.xml',
        :auth       => {
          'user' => 'username',
          'pass' => 'password',
          'uri'  => 'http://uri'
        },
        :client_maps => [ 'testing', ],
      } }
      it {
        should contain_file('/etc/repose/client-auth-n.cfg.xml').
          with_content(/docs.rackspacecloud.com/)
      }
    end

    context 'with defaults with new namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => true }"
      end

      let(:title) { 'default' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'client-auth-n.cfg.xml',
        :auth       => {
          'user' => 'username',
          'pass' => 'password',
          'uri'  => 'http://uri'
        },
        :client_maps => [ 'testing', ],
      } }
      it {
        should contain_file('/etc/repose/client-auth-n.cfg.xml').
          with_content(/docs.openrepose.org/)
      }
    end

  end
end
