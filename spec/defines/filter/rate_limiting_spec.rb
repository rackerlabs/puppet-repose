require 'spec_helper'
describe 'repose::filter::rate_limiting', type: :define do
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
          is_expected.to raise_error(Puppet::Error, %r{request_endpoint is a required})
        }
      end

      context 'only provide request_endpoint' do
        let(:title) { 'request_endpoint' }
        let(:params) do
          {
            request_endpoint: {
              'uri-regex'              => '/limits/stuff/?',
              'include_absolut_limits' => 'false',
            },
          }
        end

        it {
          is_expected.to raise_error(Puppet::Error, %r{limit_groups is a required})
        }
      end

      context 'only provide limit_groups' do
        let(:title) { 'limit_groups' }
        let(:params) do
          {
            limit_groups: [{
              'id'        => 'Some_Group',
              'groups'    => 'Some_Group',
              'default'   => true,
              'limits'    => [
                {
                  'uri'          => '/.*',
                  'uri_regex'    => '/.*',
                  'http_methods' => 'GET',
                  'unit'         => 'SECOND',
                  'value'        => '200',
                },
              ],
            }],
          }
        end

        it {
          is_expected.to raise_error(Puppet::Error, %r{request_endpoint is a required})
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
          is_expected.to contain_file('/etc/repose/rate-limiting.cfg.xml').with_ensure(
            'absent',
          )
        }
      end

      context 'providing parameters' do
        let(:title) { 'validator' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'rate-limiting.cfg.xml',
            request_endpoint: {
              'uri-regex' => '/limits/stuff/?',
              'include_absolut_limits' => false,
            },
            limit_groups: [{
              'id' => 'Some_Group',
              'groups'    => 'Some_Group',
              'default'   => true,
              'limits'    => [
                {
                  'id'           => 'some_limit_id',
                  'uri'          => '/.*',
                  'uri_regex'    => '/.*',
                  'http_methods' => 'GET',
                  'unit'         => 'SECOND',
                  'value'        => '200',
                },
              ],
            }],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/rate-limiting.cfg.xml')
            .with(
              'ensure' => 'file',
              'owner'  => 'repose',
              'group'  => 'repose',
              'mode'   => '0660',
            )
            .with_content(%r{<request-endpoint uri-regex=\"\/limits\/stuff\/\?\" include-absolute-limits=\"\"\/>})
            .with_content(%r{<limit-group id=\"Some_Group\" groups=\"Some_Group\" default=\"true\">})
            .with_content(%r{<limit id=\"some_limit_id\" uri=\"\/\.\*\" uri-regex=\"\/\.\*\" http-methods=\"GET\" unit=\"SECOND\" value=\"200\" \/>})
        }
      end

      context 'providing parameters, skipping limit id for repose < 5.0.0' do
        let(:title) { 'validator' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'rate-limiting.cfg.xml',
            request_endpoint: {
              'uri-regex' => '/limits/stuff/?',
              'include_absolut_limits' => false,
            },
            limit_groups: [{
              'id' => 'Some_Group',
              'groups'    => 'Some_Group',
              'default'   => true,
              'limits'    => [
                {
                  'uri'          => '/.*',
                  'uri_regex'    => '/.*',
                  'http_methods' => 'GET',
                  'unit'         => 'SECOND',
                  'value'        => '200',
                },
              ],
            }],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/rate-limiting.cfg.xml')
            .with(
              'ensure' => 'file',
              'owner'  => 'repose',
              'group'  => 'repose',
              'mode'   => '0660',
            )
            .with_content(%r{<request-endpoint uri-regex=\"\/limits\/stuff\/\?\" include-absolute-limits=\"\"\/>})
            .with_content(%r{<limit-group id=\"Some_Group\" groups=\"Some_Group\" default=\"true\">})
            .with_content(%r{<limit uri=\"\/\.\*\" uri-regex=\"\/\.\*\" http-methods=\"GET\" unit=\"SECOND\" value=\"200\" \/>})
        }
      end

      context 'providing overlimit' do
        let(:title) { 'validator' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'rate-limiting.cfg.xml',
            request_endpoint: {
              'uri-regex' => '/limits/stuff/?',
              'include_absolut_limits' => false,
            },
            overlimit_429: 'true',
            limit_groups: [{
              'id' => 'Some_Group',
              'groups'    => 'Some_Group',
              'default'   => true,
              'limits'    => [
                {
                  'uri'          => '/.*',
                  'uri_regex'    => '/.*',
                  'http_methods' => 'GET',
                  'unit'         => 'SECOND',
                  'value'        => '200',
                },
              ],
            }],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/rate-limiting.cfg.xml')
            .with(
              'ensure' => 'file',
              'owner'  => 'repose',
              'group'  => 'repose',
              'mode'   => '0660',
            )
            .with_content(%r{overLimit-429-responseCode=\"true\"})
            .with_content(%r{<request-endpoint uri-regex=\"\/limits\/stuff\/\?\" include-absolute-limits=\"\"\/>})
            .with_content(%r{<limit-group id=\"Some_Group\" groups=\"Some_Group\" default=\"true\">})
            .with_content(%r{<limit uri=\"\/\.\*\" uri-regex=\"\/\.\*\" http-methods=\"GET\" unit=\"SECOND\" value=\"200\" \/>})
        }
      end
    end
  end
end
