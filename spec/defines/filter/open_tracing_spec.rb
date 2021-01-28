require 'spec_helper'
describe 'repose::filter::open_tracing', :type => :define do
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
          should raise_error(Puppet::Error, /either udp or http connection parameters must be defined/)
        }
      end

      context 'with ensure absent' do
        let(:title) { 'default' }
        let(:params) { {
          :ensure => 'absent',
          :http_connection_endpoint => 'http://localhost'
        } }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_ensure(
            'absent')
        }
      end

      context 'providing http connection - endpoint' do
        let(:title) { 'connection_http_endpoint' }
        let(:params) { {
          :ensure     => 'present',
          :service_name => 'test-repose',
          :http_connection_endpoint => 'http://example.com/api/traces',
          :constant_toggle => 'on'
        } }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660')
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/connection-http endpoint=\"http:\/\/example.com\/api\/traces\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name=\"test-repose\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/<sampling-constant/)
        }
      end

      context 'providing http connection - only username' do
        let(:title) { 'connection_http_only_username' }
        let(:params) { {
          :ensure     => 'present',
          :service_name => 'test-repose',
          :http_connection_endpoint => 'http://example.com/api/traces',
          :http_connection_username => 'reposeuser',
          :constant_toggle => 'on'
        } }
        it {
          should raise_error(Puppet::Error, /must define password since username is defined/)
        }
      end

      context 'providing http connection - username + password' do
        let(:title) { 'connection_http_username_and_password' }
        let(:params) { {
          :ensure     => 'present',
          :service_name => 'test-repose',
          :http_connection_endpoint => 'http://example.com/api/traces',
          :http_connection_username => 'reposeuser',
          :http_connection_password => 'reposepass',
          :constant_toggle => 'on'
        } }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660')
          }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/connection-http endpoint=\"http:\/\/example.com\/api\/traces\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/username=\"reposeuser\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/password=\"reposepass\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name=\"test-repose\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/<sampling-constant/)
        }
      end

      context 'providing http connection - username + password + token' do
        let(:title) { 'connection_http_username_and_password_and_token' }
        let(:params) { {
          :ensure     => 'present',
          :service_name => 'test-repose',
          :http_connection_endpoint => 'http://example.com/api/traces',
          :http_connection_username => 'reposeuser',
          :http_connection_password => 'reposepass',
          :http_connection_token    => 'mytoken',
          :constant_toggle => 'on'
        } }
        it {
          should raise_error(Puppet::Error, /cannot define both token and username for http/)
        }
      end

      context 'providing http connection - only token' do
        let(:title) { 'connection_http_only_token' }
        let(:params) { {
          :ensure     => 'present',
          :service_name => 'test-repose',
          :http_connection_endpoint => 'http://example.com/api/traces',
          :http_connection_token    => 'mytoken',
          :constant_toggle => 'on'
        } }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660')
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/connection-http endpoint=\"http:\/\/example.com\/api\/traces\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name=\"test-repose\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/token=\"mytoken\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/<sampling-constant toggle=\"on\"/)
        }
      end

      context 'providing http connection - no endpoint' do
        let(:title) { 'connection_http_no_endpoint' }
        let(:params) { {
          :ensure     => 'present',
          :service_name => 'test-repose',
          :http_connection_token    => 'mytoken',
          :constant_toggle => 'on'
        } }
        it {
          should raise_error(Puppet::Error, /either udp or http connection parameters must be defined/)
        }
      end

      context 'providing udp connection' do
        let(:title) { 'connection_udp' }
        let(:params) { {
          :ensure     => 'present',
          :service_name => 'test-repose',
          :udp_connection_host => 'newhost.example.com',
          :udp_connection_port => 5775,
          :constant_toggle => 'on'
        } }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660')
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/connection-udp port=\"5775\" host=\"newhost.example.com\" /)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name=\"test-repose\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/<sampling-constant toggle=\"on\"/)
        }
      end

      context 'providing udp connection - host IP4' do
        let(:title) { 'connection_udp_only_host' }
        let(:params) { {
          :ensure     => 'present',
          :service_name => 'test-repose',
          :udp_connection_host => '127.0.0.1',
          :udp_connection_port => 5775,
          :constant_toggle => 'on'
        } }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660')
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/connection-udp port=\"5775\" host=\"127.0.0.1\" /)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name=\"test-repose\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/<sampling-constant toggle=\"on\"/)
        }
      end

      context 'providing udp connection - host IP6' do
        let(:title) { 'connection_udp_only_host' }
        let(:params) { {
          :ensure     => 'present',
          :service_name => 'test-repose',
          :udp_connection_host => '2001:0db8:85a3:0000:0000:8a2e:0370:7334',
          :udp_connection_port => 5775,
          :constant_toggle => 'on'
        } }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660')
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/connection-udp port=\"5775\" host=\"2001:0db8:85a3:0000:0000:8a2e:0370:7334\" /)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name=\"test-repose\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/<sampling-constant toggle=\"on\"/)
        }
      end

      context 'providing no sampling' do
        let(:title) { 'connection_http_endpoint' }
        let(:params) { {
          :ensure     => 'present',
          :service_name => 'test-repose',
          :http_connection_endpoint => 'http://example.com/api/traces'
        } }
        it {
          raise_error(Puppet::Error, /one of sampling parameters must be defined/)
        }
      end

      context 'providing constant sampling - default' do
        let(:title) { 'constant_sampling_default' }
        let(:params) { {
          :ensure     => 'present',
          :service_name => 'test-repose',
          :http_connection_token    => 'mytoken',
          :http_connection_endpoint => 'http://example.com/api/traces',
          :constant_toggle => 'on'
        } }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660')
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/connection-http endpoint=\"http:\/\/example.com\/api\/traces\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name=\"test-repose\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/token=\"mytoken\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/<sampling-constant/)
        }
      end

      context 'providing constant sampling - off' do
        let(:title) { 'constant_sampling_off' }
        let(:params) { {
          :ensure     => 'present',
          :service_name => 'test-repose',
          :http_connection_token    => 'mytoken',
          :http_connection_endpoint => 'http://example.com/api/traces',
          :constant_toggle => 'off'
        } }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660')
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/connection-http endpoint=\"http:\/\/example.com\/api\/traces\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name=\"test-repose\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/token=\"mytoken\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/<sampling-constant toggle=\"off\"/)
        }
      end

      context 'providing rate limiting sampling - set' do
        let(:title) { 'rate_limiting_sampling_set' }
        let(:params) { {
          :ensure     => 'present',
          :service_name => 'test-repose',
          :http_connection_token    => 'mytoken',
          :http_connection_endpoint => 'http://example.com/api/traces',
          :rate_limiting_max_traces_per_second => 5.6
        } }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660')
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/connection-http endpoint=\"http:\/\/example.com\/api\/traces\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name=\"test-repose\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/token=\"mytoken\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/<sampling-rate-limiting max-traces-per-second=\"5.6\"/)
        }
      end

      context 'providing probabilistic sampling - set' do
        let(:title) { 'probabilistic_sampling_set' }
        let(:params) { {
          :ensure     => 'present',
          :service_name => 'test-repose',
          :http_connection_token    => 'mytoken',
          :http_connection_endpoint => 'http://example.com/api/traces',
          :probability => 1.0
        } }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660')
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/connection-http endpoint=\"http:\/\/example.com\/api\/traces\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/service-name=\"test-repose\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/token=\"mytoken\"/)
        }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with_content(/<sampling-probabilistic probability=\"1.0\"/)
        }
      end

      context 'validate entries' do

        context 'validate connection_host only' do
          let(:title) { 'validate_connection_host_only' }
          let(:params) { {
            :ensure     => 'present',
            :service_name => 'test-repose',
            :udp_connection_host => 'localhost'
          } }
          it {
            should raise_error(Puppet::Error, /udp host and udp port must both be defined/)
          }
        end

        context 'validate connection_port only' do
          let(:title) { 'validate_connection_port_only' }
    
          let(:params) { {
            :ensure     => 'present',
            :service_name => 'test-repose',
            :udp_connection_port => 5755
          } }
          it {
            should raise_error(Puppet::Error, /udp host and udp port must both be defined/)
          }
        end



        context 'validate constant_toggle' do
          let(:title) { 'validate_constant_toggle' }
    
          let(:params) { {
            :ensure     => 'present',
            :service_name => 'test-repose',
            :http_connection_endpoint => 'http://localhost/api/traces',
            :constant_toggle => 'random'
          } }
          it {
            should raise_error(Puppet::Error, /'constant_toggle' expects an undef value or a match for Enum\['off', 'on'\], got 'random'/)
          }
        end

        context 'validate max_traces_per_second' do
          let(:title) { 'validate_max_traces_per_second' }
    
          let(:params) { {
            :ensure     => 'present',
            :service_name => 'test-repose',
            :http_connection_endpoint => 'http://localhost/api/traces',
            :rate_limiting_max_traces_per_second => 'random'
          } }
          it {
            should raise_error(Puppet::Error, /'rate_limiting_max_traces_per_second' expects a value of type Undef or Float, got String/)
          }
        end

        context 'validate probability' do
          let(:title) { 'validate_probability' }
    
          let(:params) { {
            :ensure     => 'present',
            :service_name => 'test-repose',
            :http_connection_endpoint => 'http://localhost/api/traces',
            :probability => 'random'
          } }
          it {
            should raise_error(Puppet::Error, /'probability' expects a value of type Undef or Float, got String/)
          }
        end
      end
    end
  end
end