require 'spec_helper'
describe 'repose::filter::keystone_v2', :type => :define do
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
          should raise_error(Puppet::Error, /uri is a required parameter/)
        }
      end

      context 'with ensure absent' do
        let(:title) { 'default' }
        let(:params) { {
          :ensure => 'absent'
        } }
        it {
          should contain_file('/etc/repose/keystone-v2.cfg.xml').with_ensure(
            'absent')
        }
      end

      context 'providing a uri' do
        let(:title) { 'default' }
        let(:params) { {
          :ensure   => 'present',
          :filename => 'keystone-v2.cfg.xml',
          :uri      => 'http://uri',
        } }
        it {
          should contain_file('/etc/repose/keystone-v2.cfg.xml').with(
            :ensure => 'file',
            :owner => 'repose',
            :group => 'repose'
          ) }
        it { should contain_file('/etc/repose/keystone-v2.cfg.xml').
            with_content(/identity-service\s+uri=\"http:\/\/uri\"/) }
      end

      context 'providing connection_pool_id' do
        let(:title) { 'default' }
        let(:params) { {
            :ensure              => 'present',
            :filename            => 'keystone-v2.cfg.xml',
            :uri  => 'http://uri',
            :connection_pool_id => 'my-connection-pool',
        } }
        it {
          should contain_file('/etc/repose/keystone-v2.cfg.xml').with(
              :ensure => 'file',
              :owner => 'repose',
              :group => 'repose'
          ) }
        it { should contain_file('/etc/repose/keystone-v2.cfg.xml'). 
              with_content(/identity-service\s+uri=\"http:\/\/uri\"/).
              with_content(/connection-pool-id=\"my-connection-pool\"/) }
      end

      context 'providing header options' do
        let(:title) { 'default' }
        let(:params) { {
            :ensure              => 'present',
            :filename            => 'keystone-v2.cfg.xml',
            :uri  => 'http://uri',
            :send_roles => 'true',
            :send_groups => 'true',
            :send_catalog => 'true',
        } }
        it {
          should contain_file('/etc/repose/keystone-v2.cfg.xml').with(
              :ensure => 'file',
              :owner => 'repose',
              :group => 'repose'
          ) }
        it { should contain_file('/etc/repose/keystone-v2.cfg.xml'). 
              with_content(/identity-service\s+uri=\"http:\/\/uri\"/).
              with_content(/set-roles-in-header=\"true\"/).
              with_content(/set-groups-in-header=\"true\"/).
              with_content(/set-catalog-in-header=\"true\"/) }
      end

      context 'providing rcn roles' do
        let(:title) { 'default' }
        let(:params) { {
            :ensure              => 'present',
            :filename            => 'keystone-v2.cfg.xml',
            :uri  => 'http://uri',
            :apply_rcn_roles => 'true',
        } }
        it {
          should contain_file('/etc/repose/keystone-v2.cfg.xml').with(
              :ensure => 'file',
              :owner => 'repose',
              :group => 'repose'
          ) }
        it { should contain_file('/etc/repose/keystone-v2.cfg.xml'). 
              with_content(/identity-service\s+uri=\"http:\/\/uri\"/).
              with_content(/apply-rcn-roles=\"true\"/) }
      end

      context 'providing delegating' do
        let(:title) { 'default' }
        let(:params) { {
            :ensure     => 'present',
            :filename   => 'keystone-v2.cfg.xml',
            :uri        => 'http://uri',
            :delegating          => 'true',
            :delegating_quality  => '0.9'
        } }
        it {
          should contain_file('/etc/repose/keystone-v2.cfg.xml').with(
              :ensure => 'file',
              :owner => 'repose',
              :group => 'repose'
          ) }
        it { should contain_file('/etc/repose/keystone-v2.cfg.xml'). 
              with_content(/identity-service\s+uri=\"http:\/\/uri\"/).
              with_content(/delegating quality="0.9"/) }
      end

      context 'providing delegating with no quality' do
        let(:title) { 'default' }
        let(:params) { {
            :ensure      => 'present',
            :filename    => 'keystone-v2.cfg.xml',
            :uri         => 'http://uri',
            :delegating  => 'true'
        } }
        it {
          should contain_file('/etc/repose/keystone-v2.cfg.xml').with(
              :ensure => 'file',
              :owner  => 'repose',
              :group  => 'repose'
          ) }
        it { should contain_file('/etc/repose/keystone-v2.cfg.xml'). 
              with_content(/identity-service\s+uri=\"http:\/\/uri\"/).
              with_content(/delegating\/>/) }
      end

      context 'providing whitelist' do
        let(:title) { 'default' }
        let(:params) { {
            :ensure      => 'present',
            :filename    => 'keystone-v2.cfg.xml',
            :uri         => 'http://uri',
            :white_lists   => ['banana', 'phone']
        } }
        it {
          should contain_file('/etc/repose/keystone-v2.cfg.xml').with(
              :ensure => 'file',
              :owner  => 'repose',
              :group  => 'repose'
          ) }
        it { should contain_file('/etc/repose/keystone-v2.cfg.xml'). 
              with_content(/identity-service\s+uri=\"http:\/\/uri\"/).
              with_content(/<white-list>/).
              with_content(/<uri-regex>banana<\/uri-regex>/).
              with_content(/<uri-regex>phone<\/uri-regex>/) }
      end

      context 'providing cache info' do
        let(:title) { 'default' }
        let(:params) { {
          :ensure              => 'present',
          :filename            => 'keystone-v2.cfg.xml',
          :uri                 => 'http://uri',
          :cache_variability   => '5',
          :token_cache_timeout => '600000',
          :group_cache_timeout => '606060',
          :endpoints_cache_timeout => '666666',
          :atom_feed_id        => 'foo'
        } }
        it {
          should contain_file('/etc/repose/keystone-v2.cfg.xml').with(
            :ensure => 'file',
            :owner => 'repose',
            :group => 'repose'
          ) }
        it { should contain_file('/etc/repose/keystone-v2.cfg.xml'). 
              with_content(/identity-service\s+uri=\"http:\/\/uri\"/).
              with_content(/<cache>/).
              with_content(/<timeouts variability=\"5\">/).
              with_content(/<token>600000<\/token>/).
              with_content(/<group>606060<\/group>/).
              with_content(/<endpoints>666666<\/endpoints>/).
              with_content(/<atom-feed id=\"foo\"\/>/) }
      end

      context 'providing tenant details' do
        let(:title) { 'default' }
        let(:params) { {
            :ensure              => 'present',
            :filename            => 'keystone-v2.cfg.xml',
            :uri                 => 'http://uri',
            :send_all_tenant_ids => true,
            :tenant_regexs       => ['/foo', '/bar'],
            :legacy_roles_mode   => false,
            :send_tenant_quality => true,
            :default_tenant_quality => '0.9',
            :uri_tenant_quality  => '0.8',
            :roles_tenant_quality => '0.7',
        } }
        it {
          should contain_file('/etc/repose/keystone-v2.cfg.xml').with(
                    :ensure => 'file',
                    :owner => 'repose',
                    :group => 'repose'
                ) }
        it { should contain_file('/etc/repose/keystone-v2.cfg.xml'). 
              with_content(/identity-service\s+uri=\"http:\/\/uri\"/).
              with_content(/<tenant-handling send-all-tenant-ids=\"true\"/).
              with_content(/<validate-tenant enable-legacy-roles-mode=\"false\"/).
              with_content(/<uri-extraction-regex>\/foo<\/uri-extraction-regex>/).
              with_content(/<uri-extraction-regex>\/bar<\/uri-extraction-regex>/).
              with_content(/<send-tenant-id-quality/).
              with_content(/default-tenant-quality=\"0.9\"/).
              with_content(/uri-tenant-quality=\"0.8\"/).
              with_content(/roles-tenant-quality=\"0.7\"/) }
      end

      context 'fails when tenant quality is turned off but values are provided' do
        let(:title) { 'default' }
        let(:params) { {
            :ensure              => 'present',
            :filename            => 'keystone-v2.cfg.xml',
            :uri                 => 'http://uri',
            :send_tenant_quality => false,
            :default_tenant_quality => '0.9',
        } }
        it {
          should raise_error(Puppet::Error, /setting tenant quality levels doesn\'t work when tenant qualities is turned off/)
        }
      end

      context 'providing endpoint validation' do
        let(:title) { 'default' }
        let(:params) { {
            :ensure              => 'present',
            :filename            => 'keystone-v2.cfg.xml',
            :uri          => 'http://uri',
            :endpoint_url => 'http://uri',
            :endpoint_region => 'ORD',
            :endpoint_name => 'foo',
            :endpoint_type => 'compute',
        } }
        it {
          should contain_file('/etc/repose/keystone-v2.cfg.xml').with(
              :ensure => 'file',
              :owner => 'repose',
              :group => 'repose'
          ) }
        it { should contain_file('/etc/repose/keystone-v2.cfg.xml'). 
              with_content(/identity-service\s+uri=\"http:\/\/uri\"/).
              with_content(/require-service-endpoint/).
              with_content(/public-url=\"http:\/\/uri\"/).
              with_content(/region=\"ORD\"/).
              with_content(/name=\"foo\"/).
              with_content(/type=\"compute\"/)}
      end

      context 'endpoint fails without url' do
        let(:title) { 'default' }
        let(:params) { {
            :ensure              => 'present',
            :filename            => 'keystone-v2.cfg.xml',
            :uri          => 'http://uri',
            :endpoint_region => 'ORD',
        } }
        it {
          should raise_error(Puppet::Error, /endpoint_url is required when doing endpoint catalog checks/)
        }
      end

      context 'providing pre_authorized_roles' do
        let(:title) { 'default' }
        let(:params) { {
            :ensure              => 'present',
            :filename            => 'keystone-v2.cfg.xml',
            :uri  => 'http://uri',
            :pre_authorized_roles => [ 'role' ],
        } }
        it {
          should contain_file('/etc/repose/keystone-v2.cfg.xml').with(
              :ensure => 'file',
              :owner => 'repose',
              :group => 'repose'
          ) }
        it { should contain_file('/etc/repose/keystone-v2.cfg.xml'). 
              with_content(/identity-service\s+uri=\"http:\/\/uri\"/).
              with_content(/pre-authorized-roles/).
              with_content(/<role>role<\/role>/) }
      end
    end
  end
end