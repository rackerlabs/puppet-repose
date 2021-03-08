require 'spec_helper'
describe 'repose::filter::system_model', type: :define do
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
          is_expected.to raise_error(%r{nodes is a required})
        }
      end

      context 'app_name only' do
        let(:title) { 'app_name' }
        let(:params) do
          {
            app_name: 'repose',
          }
        end

        it {
          is_expected.to raise_error(%r{nodes is a required})
        }
      end

      context 'app_name and nodes' do
        let(:title) { 'default' }
        let(:params) do
          {
            app_name: 'repose',
            nodes: ['app1', 'app2'],
          }
        end

        it {
          is_expected.to raise_error(%r{filters is a required})
        }
      end

      context 'app_name, nodes and filters' do
        let(:title) { 'default' }
        let(:params) do
          {
            app_name: 'repose',
            nodes: ['app1', 'app2'],
            filters: {
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
          }
        end

        it {
          is_expected.to raise_error(%r{endpoints is a required})
        }
      end

      context 'providing all parameters but not running on ssl' do
        let(:title) { 'validator' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'system-model.cfg.xml',
            app_name: 'repose',
            nodes: ['app1', 'app2'],
            filters: {
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
            endpoints: [
              {
                'id'        => 'localhost',
                'protocol'  => 'http',
                'hostname'  => 'localhost',
                'root-path' => '',
                'port'      => '80',
                'default'   => 'true',
              },
            ],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/system-model.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660',
          )
            .with_content(%r{id="repose_app1"})
            .with_content(%r{hostname="app1"})
            .with_content(%r{http-port="8080"})
            .without_content(%r{https-port=})
            .with_content(%r{name="content-normalization"})
            .with_content(%r{configuration="pre-ratelimit-httplog.cfg.xml" name="http-logging"})
            .with_content(%r{name="ip-identity"})
            .with_content(%r{name="client-auth"})
            .with_content(%r{uri-regex=".*"})
            .with_content(%r{name="rate-limiting"})
            .with_content(%r{configuration="http-logging.cfg.xml" name="http-logging"})
            .with_content(%r{name="compression"})
                                                                         .with_content(%r{endpoint default="true" hostname="localhost" id="localhost" port="80" protocol="http" root-path=""})
        }
      end

      context 'providing all parameters but only running on ssl' do
        let(:title) { 'validator' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'system-model.cfg.xml',
            app_name: 'repose',
            nodes: ['app1', 'app2'],
            https_port: 8443,
            filters: {
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
            endpoints: [
              {
                'id'        => 'localhost',
                'protocol'  => 'http',
                'hostname'  => 'localhost',
                'root-path' => '',
                'port'      => '80',
                'default'   => 'true',
              },
            ],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/system-model.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660',
          )
            .with_content(%r{id="repose_app1"})
            .with_content(%r{hostname="app1"})
            .with_content(%r{https-port="8443"})
            .with_content(%r{name="content-normalization"})
            .with_content(%r{configuration="pre-ratelimit-httplog.cfg.xml" name="http-logging"})
            .with_content(%r{name="ip-identity"})
            .with_content(%r{name="client-auth"})
            .with_content(%r{uri-regex=".*"})
            .with_content(%r{name="rate-limiting"})
            .with_content(%r{configuration="http-logging.cfg.xml" name="http-logging"})
            .with_content(%r{name="compression"})
                                                                         .with_content(%r{endpoint default="true" hostname="localhost" id="localhost" port="80" protocol="http" root-path=""})
        }
      end

      context 'providing all parameters' do
        let(:title) { 'validator' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'system-model.cfg.xml',
            app_name: 'repose',
            nodes: ['app1', 'app2'],
            https_port: 8443,
            filters: {
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
            endpoints: [
              {
                'id'        => 'localhost',
                'protocol'  => 'http',
                'hostname'  => 'localhost',
                'root-path' => '',
                'port'      => 80,
                'default'   => true,
              },
            ],
            tracing_header: { 'secondary-plain-text' => 'true' },
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/system-model.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660',
          )
            .with_content(%r{id="repose_app1"})
            .with_content(%r{hostname="app1"})
            .with_content(%r{http-port="8080"})
            .with_content(%r{https-port="8443"})
            .with_content(%r{name="content-normalization"})
            .with_content(%r{configuration="pre-ratelimit-httplog.cfg.xml" name="http-logging"})
            .with_content(%r{name="ip-identity"})
            .with_content(%r{name="client-auth"})
            .with_content(%r{uri-regex=".*"})
            .with_content(%r{name="rate-limiting"})
            .with_content(%r{configuration="http-logging.cfg.xml" name="http-logging"})
            .with_content(%r{name="compression"})
            .with_content(%r{endpoint default="true" hostname="localhost" id="localhost" port="80" protocol="http" root-path=""})
                                                                         .with_content(%r{tracing-header secondary-plain-text="true"})
        }
      end

      context 'with defaults' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'system-model.cfg.xml',
            app_name: 'repose',
            nodes: ['app1', 'app2'],
            filters: {
              10 => { 'name' => 'ip-identity' },
            },
            endpoints: [
              {
                'id'        => 'localhost',
                'protocol'  => 'http',
                'hostname'  => 'localhost',
                'root-path' => '',
                'port'      => 80,
                'default'   => true,
              },
            ],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/system-model.cfg.xml')
            .without_content(%r{tracing-header})
            .without_content(%r{rewrite-host-header})
            .without_content(%r{services})
        }
      end
    end
  end
end
