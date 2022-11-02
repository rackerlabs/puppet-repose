require 'spec_helper'
describe 'repose::filter::keystone_v2', type: :define do
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
          is_expected.to raise_error(Puppet::Error, %r{uri is a required parameter})
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
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml').with_ensure(
            'absent',
          )
        }
      end

      context 'providing a uri' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'keystone-v2.cfg.xml',
            uri: 'http://uri',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml')
            .with_content(%r{identity-service\s+uri=\"http:\/\/uri\"})
        }
      end

      context 'providing connection_pool_id' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'keystone-v2.cfg.xml',
            uri: 'http://uri',
            connection_pool_id: 'my-connection-pool',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml')
            .with_content(%r{identity-service\s+uri=\"http:\/\/uri\"})
            .with_content(%r{connection-pool-id=\"my-connection-pool\"})
        }
      end

      context 'providing header options' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'keystone-v2.cfg.xml',
            uri: 'http://uri',
            send_roles: true,
            send_groups: true,
            send_catalog: true,
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml')
            .with_content(%r{identity-service\s+uri=\"http:\/\/uri\"})
            .with_content(%r{set-roles-in-header=\"true\"})
            .with_content(%r{set-groups-in-header=\"true\"})
            .with_content(%r{set-catalog-in-header=\"true\"})
        }
      end

      context 'providing rcn roles' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'keystone-v2.cfg.xml',
            uri: 'http://uri',
            apply_rcn_roles: true,
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml')
            .with_content(%r{identity-service\s+uri=\"http:\/\/uri\"})
            .with_content(%r{apply-rcn-roles=\"true\"})
        }
      end

      context 'providing delegating' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'keystone-v2.cfg.xml',
            uri: 'http://uri',
            delegating: true,
            delegating_quality: 0.9,
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml')
            .with_content(%r{identity-service\s+uri=\"http:\/\/uri\"})
            .with_content(%r{delegating quality="0.9"})
        }
      end

      context 'providing delegating with no quality' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'keystone-v2.cfg.xml',
            uri: 'http://uri',
            delegating: true,
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml')
            .with_content(%r{identity-service\s+uri=\"http:\/\/uri\"})
            .with_content(%r{delegating\/>})
        }
      end

      context 'providing whitelist' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'keystone-v2.cfg.xml',
            uri: 'http://uri',
            white_lists: ['banana', 'phone'],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml')
            .with_content(%r{identity-service\s+uri=\"http:\/\/uri\"})
            .with_content(%r{<white-list>})
            .with_content(%r{<uri-regex>banana<\/uri-regex>})
            .with_content(%r{<uri-regex>phone<\/uri-regex>})
        }
      end

      context 'providing cache info' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'keystone-v2.cfg.xml',
            uri: 'http://uri',
            cache_variability: '5',
            token_cache_timeout: '600000',
            group_cache_timeout: '606060',
            endpoints_cache_timeout: '666666',
            atom_feed_id: 'foo',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml')
            .with_content(%r{identity-service\s+uri=\"http:\/\/uri\"})
            .with_content(%r{<cache>})
            .with_content(%r{<timeouts variability=\"5\">})
            .with_content(%r{<token>600000<\/token>})
            .with_content(%r{<group>606060<\/group>})
            .with_content(%r{<endpoints>666666<\/endpoints>})
            .with_content(%r{<atom-feed id=\"foo\"\/>})
        }
      end

      context 'providing tenant details' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'keystone-v2.cfg.xml',
            uri: 'http://uri',
            send_all_tenant_ids: true,
            tenant_regexs: ['/foo', '/bar'],
            legacy_roles_mode: false,
            send_tenant_quality: true,
            default_tenant_quality: 0.9,
            uri_tenant_quality: 0.8,
            roles_tenant_quality: 0.7,
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml')
            .with_content(%r{identity-service\s+uri=\"http:\/\/uri\"})
            .with_content(%r{<tenant-handling send-all-tenant-ids=\"true\"})
            .with_content(%r{<validate-tenant enable-legacy-roles-mode=\"false\"})
            .with_content(%r{<uri-extraction-regex>\/foo<\/uri-extraction-regex>})
            .with_content(%r{<uri-extraction-regex>\/bar<\/uri-extraction-regex>})
            .with_content(%r{<send-tenant-id-quality})
            .with_content(%r{default-tenant-quality=\"0.9\"})
            .with_content(%r{uri-tenant-quality=\"0.8\"})
            .with_content(%r{roles-tenant-quality=\"0.7\"})
        }
      end

      context 'fails when tenant quality is turned off but values are provided' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'keystone-v2.cfg.xml',
            uri: 'http://uri',
            send_tenant_quality: false,
            default_tenant_quality: 0.9,
          }
        end

        it {
          is_expected.to raise_error(Puppet::Error, %r{setting tenant quality levels doesn\'t work when tenant qualities is turned off})
        }
      end

      context 'providing endpoint validation' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'keystone-v2.cfg.xml',
            uri: 'http://uri',
            endpoint_url: 'http://uri',
            endpoint_region: 'ORD',
            endpoint_name: 'foo',
            endpoint_type: 'compute',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml')
            .with_content(%r{identity-service\s+uri=\"http:\/\/uri\"})
            .with_content(%r{require-service-endpoint})
            .with_content(%r{public-url=\"http:\/\/uri\"})
            .with_content(%r{region=\"ORD\"})
            .with_content(%r{name=\"foo\"})
            .with_content(%r{type=\"compute\"})
        }
      end

      context 'endpoint fails without url' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'keystone-v2.cfg.xml',
            uri: 'http://uri',
            endpoint_region: 'ORD',
          }
        end

        it {
          is_expected.to raise_error(Puppet::Error, %r{endpoint_url is required when doing endpoint catalog checks})
        }
      end

      context 'providing pre_authorized_roles' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'keystone-v2.cfg.xml',
            uri: 'http://uri',
            pre_authorized_roles: ['role'],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml').with(
            ensure: 'file',
            owner: 'repose',
            group: 'repose',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/keystone-v2.cfg.xml')
            .with_content(%r{identity-service\s+uri=\"http:\/\/uri\"})
            .with_content(%r{pre-authorized-roles})
            .with_content(%r{<role>role<\/role>})
        }
      end
    end
  end
end
