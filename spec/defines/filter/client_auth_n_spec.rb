require 'spec_helper'
describe 'repose::filter::client_auth_n', :type => :define do
  let :pre_condition do
    'include repose'
  end

  context 'on RedHat' do
    let :facts do
    {
      :osfamily               => 'RedHat',
      :operationsystemrelease => '7',
    }
    end

    context 'default parameters' do
      let(:title) { 'default' }
      it {
        should raise_error(Puppet::Error, /auth is a required parameter/)
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
      it { should contain_file('/etc/repose/client-auth-n.cfg.xml').with(
          :ensure => 'file',
          :owner => 'repose',
          :group => 'repose'
        ) }
      it { should contain_file('/etc/repose/client-auth-n.cfg.xml'). 
          with_content(/identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"/).
          with_content(/client-mapping id-regex=\"testing\"/).
          with_content(/delegable=\"false\"/).
          without_content(/delegating/).
          with_content(/tenanted=\"false\"/).
          with_content(/group-cache-timeout=\"60000\"/).
          without_content(/connectionPoolId/).
          without_content(/token-cache-timeout/) }
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
      it { should contain_file('/etc/repose/client-auth-n.cfg.xml').with(
          :ensure => 'file',
          :owner => 'repose',
          :group => 'repose'
        ) }
      it { should contain_file('/etc/repose/client-auth-n.cfg.xml'). 
          with_content(/identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"/).
          with_content(/token-cache-timeout=\"600000\"/) }
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
      it { should contain_file('/etc/repose/client-auth-n.cfg.xml').with(
          :ensure => 'file',
          :owner => 'repose',
          :group => 'repose'
        ) }
      it { should contain_file('/etc/repose/client-auth-n.cfg.xml'). 
          with_content(/identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"/).
          with_content(/connectionPoolId=\"my-connection-pool\"/) }
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
      it { should contain_file('/etc/repose/client-auth-n.cfg.xml').with(
          :ensure => 'file',
          :owner => 'repose',
          :group => 'repose' ) }
      it { should contain_file('/etc/repose/client-auth-n.cfg.xml'). 
          with_content(/identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"/).
          with_content(/ignore-tenant-roles/).
          with_content(/<role>role<\/role>/) }
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
      it { should contain_file('/etc/repose/client-auth-n.cfg.xml').with(
                   :ensure => 'file',
                   :owner => 'repose',
                   :group => 'repose'
               ) }
      it { should contain_file('/etc/repose/client-auth-n.cfg.xml'). 
                   with_content(/identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"/).
                   without_content(/send-all-tenant-ids/) }
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
      it { should contain_file('/etc/repose/client-auth-n.cfg.xml').with(
                   :ensure => 'file',
                   :owner => 'repose',
                   :group => 'repose'
               ) }
      it { should contain_file('/etc/repose/client-auth-n.cfg.xml'). 
                   with_content(/identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"/).
                   with_content(/send-all-tenant-ids=\"true\"/) }
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
        :client_maps         => [ 'testing', ],
        :delegating          => 'true',
        :delegating_quality  => '0.9'
      } }
      it { should contain_file('/etc/repose/client-auth-n.cfg.xml').with(
          :ensure => 'file',
          :owner => 'repose',
          :group => 'repose'
        ) }
      it { should contain_file('/etc/repose/client-auth-n.cfg.xml'). 
          with_content(/identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"/).
          with_content(/client-mapping id-regex=\"testing\"/).
          without_content(/delegable=/).
          with_content(/delegating quality="0.9"/).
          with_content(/tenanted=\"false\"/).
          with_content(/group-cache-timeout=\"60000\"/).
          without_content(/connectionPoolId/).
          without_content(/token-cache-timeout/) }
    end

    context 'providing delegating with no quality for repose 7+' do
      let(:title) { 'default' }
      let(:params) { {
          :ensure      => 'present',
          :filename    => 'client-auth-n.cfg.xml',
          :auth        => {
              'user' => 'username',
              'pass' => 'password',
              'uri'  => 'http://uri'
          },
          :client_maps => [ 'testing', ],
          :delegating  => 'true'
      } }
      it { should contain_file('/etc/repose/client-auth-n.cfg.xml').with(
                   :ensure => 'file',
                   :owner  => 'repose',
                   :group  => 'repose'
               ) }
      it { should contain_file('/etc/repose/client-auth-n.cfg.xml'). 
                   with_content(/identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"/).
                   with_content(/client-mapping id-regex=\"testing\"/).
                   without_content(/delegable=/).
                   with_content(/delegating\/>/).
                   with_content(/tenanted=\"false\"/).
                   with_content(/group-cache-timeout=\"60000\"/).
                   without_content(/connectionPoolId/).
                   without_content(/token-cache-timeout/) }
    end

    context 'providing token_expire_feed with use_auth=true' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure              => 'present',
        :filename            => 'client-auth-n.cfg.xml',
        :auth                => {
          'user' => 'username',
          'pass' => 'password',
          'uri'  => 'http://uri'
        },
        :token_expire_feed   => {
          'feed_url' => 'https://atomvip/identity/events',
          'use_auth' => true,
          'auth_url' => 'https://identity-service-url/v2.0',
          'user'     => 'username',
          'pass'     => 'password',
          'interval' => '60000'
        }
      } }
      it { should contain_file('/etc/repose/client-auth-n.cfg.xml').with(
          :ensure => 'file',
          :owner => 'repose',
          :group => 'repose'
        ) }
      it { should contain_file('/etc/repose/client-auth-n.cfg.xml'). 
          with_content(/atom-feeds check-interval=\"60000\"/).
          with_content(/rs-identity-feed id=\"identity-token-revocation-feed\" uri=\"https:\/\/atomvip\/identity\/events\"/).
          with_content(/isAuthed=\"true\" auth-uri=\"https:\/\/identity-service-url\/v2.0\"/).
          with_content(/user=\"username\" password=\"password\"/) }
    end

    context 'providing token_expire_feed with use_auth=false' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure              => 'present',
        :filename            => 'client-auth-n.cfg.xml',
        :auth                => {
          'user' => 'username',
          'pass' => 'password',
          'uri'  => 'http://uri'
        },
        :token_expire_feed   => {
          'feed_url' => 'https://atomvip/identity/events',
          'use_auth' => false,
          'auth_url' => 'https://identity-service-url/v2.0',
          'user'     => 'username',
          'pass'     => 'password',
          'interval' => '60000'
        }
      } }
      it { should contain_file('/etc/repose/client-auth-n.cfg.xml').with(
          :ensure => 'file',
          :owner => 'repose',
          :group => 'repose'
        ) }
      it { should contain_file('/etc/repose/client-auth-n.cfg.xml'). 
          with_content(/atom-feeds check-interval=\"60000\"/).
          with_content(/rs-identity-feed id=\"identity-token-revocation-feed\" uri=\"https:\/\/atomvip\/identity\/events\"/).
          without_content(/isAuthed=\"true\" auth-uri=\"https:\/\/identity-service-url\/v2.0\"/).
          without_content(/user=\"username\" password=\"password\"/) }
    end
  end
end
