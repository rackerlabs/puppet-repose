require 'spec_helper'
describe 'repose::filter::system_model', :type => :define do
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
          should raise_error(Puppet::Error, /nodes is a required/)
        }
      end

      context 'app_name only' do
        let(:title) { 'app_name' }
        let(:params) { {
          :app_name => 'repose'
        } }
        it {
          should raise_error(Puppet::Error, /nodes is a required/)
        }
      end

      context 'app_name and nodes' do
        let(:title) { 'default' }
        let(:params) { {
          :app_name => 'repose',
          :nodes    => ['app1', 'app2' ],
        } }
        it {
          should raise_error(Puppet::Error, /filters is a required/)
        }
      end

      context 'app_name, nodes and filters' do
        let(:title) { 'default' }
        let(:params) { {
          :app_name => 'repose',
          :nodes    => ['app1', 'app2' ],
          :filters  => {
            10 => { 'name' => 'content-normalization' },
            20 => { 'name' => 'http-logging', 'configuration' => 'pre-ratelimit-httplog.cfg.xml' },
            30 => { 'name' => 'ip-identity' },
            40 => { 'name' => 'client-auth', 'uri-regex' => '.*' },
            50 => { 'name' => 'rate-limiting' },
            60 => { 'name' => 'http-logging', 'configuration' => 'http-logging.cfg.xml' },
            70 => { 'name' => 'compression' },
            80 => { 'name' => 'translation' },
            90 => { 'name' => 'api-validator' },
            99 => { 'name' => 'default-router' },
          }
        } }
        it {
          should raise_error(Puppet::Error, /endpoints is a required/)
        }
      end

      context 'providing all parameters but not running on ssl' do
        let(:title) { 'validator' }
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'system-model.cfg.xml',
          :app_name   => 'repose',
          :nodes      => ['app1', 'app2' ],
          :filters    => {
            10 => { 'name' => 'content-normalization' },
            20 => { 'name' => 'http-logging', 'configuration' => 'pre-ratelimit-httplog.cfg.xml' },
            30 => { 'name' => 'ip-identity' },
            40 => { 'name' => 'client-auth', 'uri-regex' => '.*' },
            50 => { 'name' => 'rate-limiting' },
            60 => { 'name' => 'http-logging', 'configuration' => 'http-logging.cfg.xml' },
            70 => { 'name' => 'compression' },
            80 => { 'name' => 'translation' },
            90 => { 'name' => 'api-validator' },
            99 => { 'name' => 'default-router' },
          },
          :endpoints  => [
            {
              'id'        => 'localhost',
              'protocol'  => 'http',
              'hostname'  => 'localhost',
              'root-path' => '',
              'port'      => '80',
              'default'   => 'true'
            },
          ]
        } }
        it {
          should contain_file('/etc/repose/system-model.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/id=\"repose\"/).
            with_content(/id=\"repose_app1\"/).
            with_content(/hostname=\"app1\"/).
            with_content(/http-port=\"8080\"/).
            without_content(/https-port=/).
            with_content(/name=\"content-normalization\"/).
            with_content(/configuration=\"pre-ratelimit-httplog\.cfg\.xml\" name=\"http-logging\"/).
            with_content(/name=\"ip-identity\"/).
            with_content(/name=\"client-auth\"/).
            with_content(/uri-regex=\"\.\*\"/).
            with_content(/name=\"rate-limiting\"/).
            with_content(/configuration=\"http-logging\.cfg\.xml\" name=\"http-logging\"/).
            with_content(/name=\"compression\"/).
            with_content(/endpoint default=\"true\" hostname=\"localhost\" id=\"localhost\" port=\"80\" protocol=\"http\" root-path=\"\"/)
        }
      end

      context 'providing all parameters but only running on ssl' do
        let(:title) { 'validator' }
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'system-model.cfg.xml',
          :app_name   => 'repose',
          :nodes      => ['app1', 'app2' ],
          :port       => false,
          :https_port => '8443',
          :filters    => {
            10 => { 'name' => 'content-normalization' },
            20 => { 'name' => 'http-logging', 'configuration' => 'pre-ratelimit-httplog.cfg.xml' },
            30 => { 'name' => 'ip-identity' },
            40 => { 'name' => 'client-auth', 'uri-regex' => '.*' },
            50 => { 'name' => 'rate-limiting' },
            60 => { 'name' => 'http-logging', 'configuration' => 'http-logging.cfg.xml' },
            70 => { 'name' => 'compression' },
            80 => { 'name' => 'translation' },
            90 => { 'name' => 'api-validator' },
            99 => { 'name' => 'default-router' },
          },
          :endpoints  => [
            {
              'id'        => 'localhost',
              'protocol'  => 'http',
              'hostname'  => 'localhost',
              'root-path' => '',
              'port'      => '80',
              'default'   => 'true'
            },
          ]
        } }
        it {
          should contain_file('/etc/repose/system-model.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/id=\"repose\"/).
            with_content(/id=\"repose_app1\"/).
            with_content(/hostname=\"app1\"/).
            without_content(/http-port=/).
            with_content(/https-port=\"8443\"/).
            with_content(/name=\"content-normalization\"/).
            with_content(/configuration=\"pre-ratelimit-httplog\.cfg\.xml\" name=\"http-logging\"/).
            with_content(/name=\"ip-identity\"/).
            with_content(/name=\"client-auth\"/).
            with_content(/uri-regex=\"\.\*\"/).
            with_content(/name=\"rate-limiting\"/).
            with_content(/configuration=\"http-logging\.cfg\.xml\" name=\"http-logging\"/).
            with_content(/name=\"compression\"/).
            with_content(/endpoint default=\"true\" hostname=\"localhost\" id=\"localhost\" port=\"80\" protocol=\"http\" root-path=\"\"/)
        }
      end

      context 'providing all parameters' do
        let(:title) { 'validator' }
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'system-model.cfg.xml',
          :app_name   => 'repose',
          :nodes      => ['app1', 'app2' ],
          :https_port => '8443',
          :filters    => {
            10 => { 'name' => 'content-normalization' },
            20 => { 'name' => 'http-logging', 'configuration' => 'pre-ratelimit-httplog.cfg.xml' },
            30 => { 'name' => 'ip-identity' },
            40 => { 'name' => 'client-auth', 'uri-regex' => '.*' },
            50 => { 'name' => 'rate-limiting' },
            60 => { 'name' => 'http-logging', 'configuration' => 'http-logging.cfg.xml' },
            70 => { 'name' => 'compression' },
            80 => { 'name' => 'translation' },
            90 => { 'name' => 'api-validator' },
            99 => { 'name' => 'default-router' },
          },
          :endpoints  => [
            {
              'id'        => 'localhost',
              'protocol'  => 'http',
              'hostname'  => 'localhost',
              'root-path' => '',
              'port'      => '80',
              'default'   => 'true'
            },
          ],
          :tracing_header => { 'secondary-plain-text' => 'true' },
        } }
        it {
          should contain_file('/etc/repose/system-model.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/id=\"repose\"/).
            with_content(/id=\"repose_app1\"/).
            with_content(/hostname=\"app1\"/).
            with_content(/http-port=\"8080\"/).
            with_content(/https-port=\"8443\"/).
            with_content(/name=\"content-normalization\"/).
            with_content(/configuration=\"pre-ratelimit-httplog\.cfg\.xml\" name=\"http-logging\"/).
            with_content(/name=\"ip-identity\"/).
            with_content(/name=\"client-auth\"/).
            with_content(/uri-regex=\"\.\*\"/).
            with_content(/name=\"rate-limiting\"/).
            with_content(/configuration=\"http-logging\.cfg\.xml\" name=\"http-logging\"/).
            with_content(/name=\"compression\"/).
            with_content(/endpoint default=\"true\" hostname=\"localhost\" id=\"localhost\" port=\"80\" protocol=\"http\" root-path=\"\"/).
            with_content(/tracing-header secondary-plain-text=\"true\"/)
        }
      end

      context 'with defaults' do
        let(:title) { 'default' }
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'system-model.cfg.xml',
          :app_name   => 'repose',
          :nodes      => ['app1', 'app2' ],
          :filters    => {
            10 => { 'name' => 'ip-identity' },
          },
          :endpoints  => [
            {
              'id'        => 'localhost',
              'protocol'  => 'http',
              'hostname'  => 'localhost',
              'root-path' => '',
              'port'      => '80',
              'default'   => 'true'
            },
          ]
        } }
        it {
          should contain_file('/etc/repose/system-model.cfg.xml').
            without_content(/tracing-header/).
            without_content(/rewrite-host-header/).
            without_content(/services/)
        }
      end

      context 'defaults plus setting repose9 param' do
        let(:title) { 'default' }
        let(:params) { {
          :ensure     => 'present',
          :repose9    => 'true',
          :filename   => 'system-model.cfg.xml',
          :app_name   => 'repose',
          :nodes      => ['app1', 'app2' ],
          :filters    => {
            10 => { 'name' => 'ip-identity' },
          },
          :endpoints  => [
            {
              'id'        => 'localhost',
              'protocol'  => 'http',
              'hostname'  => 'localhost',
              'root-path' => '',
              'port'      => '80',
              'default'   => 'true'
            },
          ]
        } }
        it {
          should contain_file('/etc/repose/system-model.cfg.xml').
            without_content(/tracing-header/).
            without_content(/rewrite-host-header/).
            without_content(/repose-cluster/).
            without_content(/services/)
        }
      end

      context 'defaults plus setting repose9 param with encoded headers' do

        let(:title) { 'default' }
        let(:params) { {
            :ensure     => 'present',
            :repose9    => 'true',
            :filename   => 'system-model.cfg.xml',
            :app_name   => 'repose',
            :nodes      => ['app1', 'app2' ],
            :filters    => {
                10 => { 'name' => 'ip-identity' },
            },
            :endpoints  => [
                {
                    'id'        => 'localhost',
                    'protocol'  => 'http',
                    'hostname'  => 'localhost',
                    'root-path' => '',
                    'port'      => '80',
                    'default'   => 'true'
                },
            ],
            :encoded_headers    => ['x-user-name', 'x-rax-roles'],

        } }
        it {
          should contain_file('/etc/repose/system-model.cfg.xml').
                    without_content(/tracing-header/).
                    without_content(/rewrite-host-header/).
                    without_content(/repose-cluster/).
                    without_content(/services/).
                    with_content(/url-encode-headers="x-user-name,x-rax-roles"/)
        }
      end
    end
  end
end