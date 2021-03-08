require 'spec_helper'
describe 'repose::filter::client_auth_n', type: :define do
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
          is_expected.to raise_error(Puppet::Error, %r{auth is a required parameter})
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
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml').with_ensure(
            'absent',
          )
        }
      end

      context 'providing a auth settings' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'client-auth-n.cfg.xml',
            auth: {
              'user' => 'username',
              'pass' => 'password',
              'uri'  => 'http://uri',
            },
            client_maps: ['testing'],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml')
            .with_content(%r{identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"})
            .with_content(%r{client-mapping id-regex=\"testing\"})
            .with_content(%r{delegable=\"false\"})
            .without_content(%r{delegating})
            .with_content(%r{tenanted=\"false\"})
            .with_content(%r{group-cache-timeout=\"60000\"})
            .without_content(%r{connectionPoolId})
            .without_content(%r{token-cache-timeout})
        }
      end

      context 'providing token_cache_timeout' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'client-auth-n.cfg.xml',
            auth: {
              'user' => 'username',
              'pass' => 'password',
              'uri'  => 'http://uri',
            },
            token_cache_timeout: '600000',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml')
            .with_content(%r{identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"})
            .with_content(%r{token-cache-timeout=\"600000\"})
        }
      end

      context 'providing connection_pool_id' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'client-auth-n.cfg.xml',
            auth: {
              'user' => 'username',
              'pass' => 'password',
              'uri'  => 'http://uri',
            },
            connection_pool_id: 'my-connection-pool',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml')
            .with_content(%r{identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"})
            .with_content(%r{connectionPoolId=\"my-connection-pool\"})
        }
      end

      context 'providing ignore_tenant_roles' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'client-auth-n.cfg.xml',
            auth: {
              'user' => 'username',
              'pass' => 'password',
              'uri'  => 'http://uri',
            },
            ignore_tenant_roles: ['role'],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml')
            .with_content(%r{identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"})
            .with_content(%r{ignore-tenant-roles})
            .with_content(%r{<role>role<\/role>})
        }
      end

      context 'do not provide send_all_tenant_ids' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'client-auth-n.cfg.xml',
            auth: {
              'user' => 'username',
              'pass' => 'password',
              'uri'  => 'http://uri',
            },
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml')
            .with_content(%r{identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"})
            .without_content(%r{send-all-tenant-ids})
        }
      end

      context 'providing send_all_tenant_ids' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'client-auth-n.cfg.xml',
            auth: {
              'user' => 'username',
              'pass' => 'password',
              'uri'  => 'http://uri',
            },
            send_all_tenant_ids: true,
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml')
            .with_content(%r{identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"})
            .with_content(%r{send-all-tenant-ids=\"true\"})
        }
      end

      context 'providing delegating for repose 7+' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'client-auth-n.cfg.xml',
            auth: {
              'user' => 'username',
              'pass' => 'password',
              'uri'  => 'http://uri',
            },
            client_maps: ['testing'],
            delegating: 'true',
            delegating_quality: '0.9',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml')
            .with_content(%r{identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"})
            .with_content(%r{client-mapping id-regex=\"testing\"})
            .without_content(%r{delegable=})
            .with_content(%r{delegating quality="0.9"})
            .with_content(%r{tenanted=\"false\"})
            .with_content(%r{group-cache-timeout=\"60000\"})
            .without_content(%r{connectionPoolId})
            .without_content(%r{token-cache-timeout})
        }
      end

      context 'providing delegating with no quality for repose 7+' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'client-auth-n.cfg.xml',
            auth: {
              'user' => 'username',
              'pass' => 'password',
              'uri'  => 'http://uri',
            },
            client_maps: ['testing'],
            delegating: 'true',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml')
            .with_content(%r{identity-service username=\"username\" password=\"password\" uri=\"http:\/\/uri\"})
            .with_content(%r{client-mapping id-regex=\"testing\"})
            .without_content(%r{delegable=})
            .with_content(%r{delegating\/>})
            .with_content(%r{tenanted=\"false\"})
            .with_content(%r{group-cache-timeout=\"60000\"})
            .without_content(%r{connectionPoolId})
            .without_content(%r{token-cache-timeout})
        }
      end

      context 'providing token_expire_feed with use_auth=true' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'client-auth-n.cfg.xml',
            auth: {
              'user' => 'username',
              'pass' => 'password',
              'uri'  => 'http://uri',
            },
            token_expire_feed: {
              'feed_url' => 'https://atomvip/identity/events',
              'use_auth' => true,
              'auth_url' => 'https://identity-service-url/v2.0',
              'user'     => 'username',
              'pass'     => 'password',
              'interval' => '60000',
            },
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml')
            .with_content(%r{atom-feeds check-interval=\"60000\"})
            .with_content(%r{rs-identity-feed id=\"identity-token-revocation-feed\" uri=\"https:\/\/atomvip\/identity\/events\"})
            .with_content(%r{isAuthed=\"true\" auth-uri=\"https:\/\/identity-service-url\/v2.0\"})
            .with_content(%r{user=\"username\" password=\"password\"})
        }
      end

      context 'providing token_expire_feed with use_auth=false' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'client-auth-n.cfg.xml',
            auth: {
              'user' => 'username',
              'pass' => 'password',
              'uri'  => 'http://uri',
            },
            token_expire_feed: {
              'feed_url' => 'https://atomvip/identity/events',
              'use_auth' => false,
              'auth_url' => 'https://identity-service-url/v2.0',
              'user'     => 'username',
              'pass'     => 'password',
              'interval' => '60000',
            },
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/client-auth-n.cfg.xml')
            .with_content(%r{atom-feeds check-interval=\"60000\"})
            .with_content(%r{rs-identity-feed id=\"identity-token-revocation-feed\" uri=\"https:\/\/atomvip\/identity\/events\"})
            .without_content(%r{isAuthed=\"true\" auth-uri=\"https:\/\/identity-service-url\/v2.0\"})
            .without_content(%r{user=\"username\" password=\"password\"})
        }
      end
    end
  end
end
