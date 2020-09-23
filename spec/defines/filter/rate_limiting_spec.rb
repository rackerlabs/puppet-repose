require 'spec_helper'
describe 'repose::filter::rate_limiting', :type => :define do
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
        should raise_error(Puppet::Error, /request_endpoint is a required/)
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
        should raise_error(Puppet::Error, /limit_groups is a required/)
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
        should raise_error(Puppet::Error, /request_endpoint is a required/)
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
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
        :global_limit_groups => [
            {
              'limits'    => [
                  {
                   'id'           => 'some_global_limit_id',
                   'uri'          => '/.*',
                   'uri_regex'    => '/.*',
                   'http_methods' => 'GET',
                   'unit'         => 'SECOND',
                   'value'        => '150'
                  },
              ]
            }
        ],
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
          with_content(/<global-limit-group>/).
          with_content(/<limit id=\"some_global_limit_id\" uri=\"\/\.\*\" uri-regex=\"\/\.\*\" http-methods=\"GET\" unit=\"SECOND\" value=\"150\" \/>/).
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
        :global_limit_groups => [
            {
                'limits'    => [
                    {
                        'id'           => 'some_global_limit_id',
                        'uri'          => '/.*',
                        'uri_regex'    => '/.*',
                        'http_methods' => 'GET',
                        'unit'         => 'SECOND',
                        'value'        => '150'
                    },
                ]
            }
        ],
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
          with_content(/<global-limit-group>/).
          with_content(/<limit id=\"some_global_limit_id\" uri=\"\/\.\*\" uri-regex=\"\/\.\*\" http-methods=\"GET\" unit=\"SECOND\" value=\"150\" \/>/).
          with_content(/<limit-group id=\"Some_Group\" groups=\"Some_Group\" default=\"true\">/).
          with_content(/<limit uri=\"\/\.\*\" uri-regex=\"\/\.\*\" http-methods=\"GET\" unit=\"SECOND\" value=\"200\" \/>/)

      }
    end

    context 'with defaults with old namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => false }"
      end

      let(:title) { 'default' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'rate-limiting.cfg.xml',
        :request_endpoint => {
          'uri-regex'              => '/limits/stuff/?',
          'include_absolut_limits' => false
        },
        :global_limit_groups => [
            {
                'limits'    => [
                    {
                        'id'           => 'some_global_limit_id',
                        'uri'          => '/.*',
                        'uri_regex'    => '/.*',
                        'http_methods' => 'GET',
                        'unit'         => 'SECOND',
                        'value'        => '150'
                    },
                ]
            }
        ],
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
        should contain_file('/etc/repose/rate-limiting.cfg.xml').
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
        :filename   => 'rate-limiting.cfg.xml',
        :request_endpoint => {
          'uri-regex'              => '/limits/stuff/?',
          'include_absolut_limits' => false
        },
        :global_limit_groups => [
            {
                'limits'    => [
                    {
                        'id'           => 'some_global_limit_id',
                        'uri'          => '/.*',
                        'uri_regex'    => '/.*',
                        'http_methods' => 'GET',
                        'unit'         => 'SECOND',
                        'value'        => '150'
                    },
                ]
            }
        ],
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
        should contain_file('/etc/repose/rate-limiting.cfg.xml').
          with_content(/docs.openrepose.org/)
      }
    end
  end
end
