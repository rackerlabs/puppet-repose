require 'spec_helper'
describe 'repose::filter::rate_limiting', :type => :define do
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
          should raise_error(Puppet::Error, /expects a value for parameter 'request_endpoint'/)
        }
      end

      context 'only provide request_endpoint' do
        let(:title) { 'request_endpoint' }
        let(:params) { {
          :request_endpoint => {
            'uri-regex'              => '/limits/stuff/?',
            'include_absolut_limits' => 'false'
          }
        } }
        it {
          should raise_error(Puppet::Error, /expects a value for parameter 'limit_groups'/)
        }
      end

      context 'only provide limit_groups' do
        let(:title) { 'limit_groups' }
        let(:params) { {
          :limit_groups => [ {
            'id'        => 'Some_Group',
            'groups'    => 'Some_Group',
            'default'   => true,
            'limits'    => [
            {
              'uri'          => '/.*',
              'uri_regex'    => '/.*',
              'http_methods' => 'GET',
              'unit'         => 'SECOND',
              'value'        => '200'
            }, ],
          } ]
        } }
        it {
          should raise_error(Puppet::Error, /expects a value for parameter 'request_endpoint'/)
        }
      end

      context 'with ensure absent' do
        let(:title) { 'default' }
        let(:params) { {
          :ensure => 'absent',
          :request_endpoint => {},
          :limit_groups => [ {} ],
        } }
        it {
          should contain_file('/etc/repose/rate-limiting.cfg.xml').with_ensure(
            'absent')
        }
      end

      context 'providing parameters' do
        let(:title) { 'validator' }
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'rate-limiting.cfg.xml',
          :request_endpoint => {
            'uri-regex'              => '/limits/stuff/?',
            'include_absolut_limits' => false
          },
          :limit_groups => [ {
            'id'        => 'Some_Group',
            'groups'    => 'Some_Group',
            'default'   => true,
            'limits'    => [
            {
              'id'           => 'some_limit_id',
              'uri'          => '/.*',
              'uri_regex'    => '/.*',
              'http_methods' => 'GET',
              'unit'         => 'SECOND',
              'value'        => '200'
            },
            ]
          } ]
        } }
        it {
          should contain_file('/etc/repose/rate-limiting.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/<request-endpoint uri-regex=\"\/limits\/stuff\/\?\" include-absolute-limits=\"\"\/>/).
            with_content(/<limit-group id=\"Some_Group\" groups=\"Some_Group\" default=\"true\">/).
            with_content(/<limit id=\"some_limit_id\" uri=\"\/\.\*\" uri-regex=\"\/\.\*\" http-methods=\"GET\" unit=\"SECOND\" value=\"200\" \/>/)

        }
      end

      context 'providing parameters, skipping limit id for repose < 5.0.0' do
        let(:title) { 'validator' }
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'rate-limiting.cfg.xml',
          :request_endpoint => {
            'uri-regex'              => '/limits/stuff/?',
            'include_absolut_limits' => false
          },
          :limit_groups => [ {
            'id'        => 'Some_Group',
            'groups'    => 'Some_Group',
            'default'   => true,
            'limits'    => [
            {
              'uri'          => '/.*',
              'uri_regex'    => '/.*',
              'http_methods' => 'GET',
              'unit'         => 'SECOND',
              'value'        => '200'
            },
            ]
          } ]
        } }
        it {
          should contain_file('/etc/repose/rate-limiting.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/<request-endpoint uri-regex=\"\/limits\/stuff\/\?\" include-absolute-limits=\"\"\/>/).
            with_content(/<limit-group id=\"Some_Group\" groups=\"Some_Group\" default=\"true\">/).
            with_content(/<limit uri=\"\/\.\*\" uri-regex=\"\/\.\*\" http-methods=\"GET\" unit=\"SECOND\" value=\"200\" \/>/)

        }
      end


      context 'providing overlimit' do
        let(:title) { 'validator' }
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'rate-limiting.cfg.xml',
          :request_endpoint => {
            'uri-regex'              => '/limits/stuff/?',
            'include_absolut_limits' => false
          },
          :overlimit_429 => 'true',
          :limit_groups => [ {
            'id'        => 'Some_Group',
            'groups'    => 'Some_Group',
            'default'   => true,
            'limits'    => [
            {
              'uri'          => '/.*',
              'uri_regex'    => '/.*',
              'http_methods' => 'GET',
              'unit'         => 'SECOND',
              'value'        => '200'
            },
            ]
          } ]
        } }
        it {
          should contain_file('/etc/repose/rate-limiting.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/overLimit-429-responseCode=\"true\"/).
            with_content(/<request-endpoint uri-regex=\"\/limits\/stuff\/\?\" include-absolute-limits=\"\"\/>/).
            with_content(/<limit-group id=\"Some_Group\" groups=\"Some_Group\" default=\"true\">/).
            with_content(/<limit uri=\"\/\.\*\" uri-regex=\"\/\.\*\" http-methods=\"GET\" unit=\"SECOND\" value=\"200\" \/>/)

        }
      end
    end
  end
end