require 'spec_helper'
describe 'repose::filter::open_tracing', type: :define do
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
          is_expected.to raise_error(Puppet::Error, %r{either udp or http connection parameters must be defined})
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
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_ensure(
            'absent',
          )
        }
      end

      context 'providing http connection - endpoint' do
        let(:title) { 'connection_http_endpoint' }
        let(:params) do
          {
            ensure: 'present',
            service_name: 'test-repose',
            http_connection_endpoint: 'http://example.com/api/traces',
            constant_toggle: 'on',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{connection-http endpoint=\"http:\/\/example.com\/api\/traces\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{service-name=\"test-repose\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-constant})
        }
      end

      context 'providing http connection - only username' do
        let(:title) { 'connection_http_only_username' }
        let(:params) do
          {
            ensure: 'present',
            service_name: 'test-repose',
            http_connection_endpoint: 'http://example.com/api/traces',
            http_connection_username: 'reposeuser',
            constant_toggle: 'on',
          }
        end

        it {
          is_expected.to raise_error(Puppet::Error, %r{must define password since username is defined})
        }
      end

      context 'providing http connection - username + password' do
        let(:title) { 'connection_http_username_and_password' }
        let(:params) do
          {
            ensure: 'present',
            service_name: 'test-repose',
            http_connection_endpoint: 'http://example.com/api/traces',
            http_connection_username: 'reposeuser',
            http_connection_password: 'reposepass',
            constant_toggle: 'on',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{connection-http endpoint=\"http:\/\/example.com\/api\/traces\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{username=\"reposeuser\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{password=\"reposepass\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{service-name=\"test-repose\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-constant})
        }
      end

      context 'providing http connection - username + password + token' do
        let(:title) { 'connection_http_username_and_password_and_token' }
        let(:params) do
          {
            ensure: 'present',
            service_name: 'test-repose',
            http_connection_endpoint: 'http://example.com/api/traces',
            http_connection_username: 'reposeuser',
            http_connection_password: 'reposepass',
            http_connection_token: 'mytoken',
            constant_toggle: 'on',
          }
        end

        it {
          is_expected.to raise_error(Puppet::Error, %r{cannot define both token and username for http})
        }
      end

      context 'providing http connection - only token' do
        let(:title) { 'connection_http_only_token' }
        let(:params) do
          {
            ensure: 'present',
            service_name: 'test-repose',
            http_connection_endpoint: 'http://example.com/api/traces',
            http_connection_token: 'mytoken',
            constant_toggle: 'on',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{connection-http endpoint=\"http:\/\/example.com\/api\/traces\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{service-name=\"test-repose\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{token=\"mytoken\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-constant toggle=\"on\"})
        }
      end

      context 'providing http connection - no endpoint' do
        let(:title) { 'connection_http_no_endpoint' }
        let(:params) do
          {
            ensure: 'present',
            service_name: 'test-repose',
            http_connection_token: 'mytoken',
            constant_toggle: 'on',
          }
        end

        it {
          is_expected.to raise_error(Puppet::Error, %r{either udp or http connection parameters must be defined})
        }
      end

      context 'providing udp connection' do
        let(:title) { 'connection_udp' }
        let(:params) do
          {
            ensure: 'present',
            service_name: 'test-repose',
            udp_connection_host: 'newhost.example.com',
            udp_connection_port: 5775,
            constant_toggle: 'on',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{connection-udp port=\"5775\" host=\"newhost.example.com\" })
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{service-name=\"test-repose\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-constant toggle=\"on\"})
        }
      end

      context 'providing udp connection - host IP4' do
        let(:title) { 'connection_udp_only_host' }
        let(:params) do
          {
            ensure: 'present',
            service_name: 'test-repose',
            udp_connection_host: '127.0.0.1',
            udp_connection_port: 5775,
            constant_toggle: 'on',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{connection-udp port=\"5775\" host=\"127.0.0.1\" })
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{service-name=\"test-repose\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-constant toggle=\"on\"})
        }
      end

      context 'providing udp connection - host IP6' do
        let(:title) { 'connection_udp_only_host' }
        let(:params) do
          {
            ensure: 'present',
            service_name: 'test-repose',
            udp_connection_host: '2001:0db8:85a3:0000:0000:8a2e:0370:7334',
            udp_connection_port: 5775,
            constant_toggle: 'on',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{connection-udp port=\"5775\" host=\"2001:0db8:85a3:0000:0000:8a2e:0370:7334\" })
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{service-name=\"test-repose\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-constant toggle=\"on\"})
        }
      end

      context 'providing no sampling' do
        let(:title) { 'connection_http_endpoint' }
        let(:params) do
          {
            ensure: 'present',
            service_name: 'test-repose',
            http_connection_endpoint: 'http://example.com/api/traces',
          }
        end

        it {
          raise_error(Puppet::Error, %r{one of sampling parameters must be defined})
        }
      end

      context 'providing constant sampling - default' do
        let(:title) { 'constant_sampling_default' }
        let(:params) do
          {
            ensure: 'present',
            service_name: 'test-repose',
            http_connection_token: 'mytoken',
            http_connection_endpoint: 'http://example.com/api/traces',
            constant_toggle: 'on',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{connection-http endpoint=\"http:\/\/example.com\/api\/traces\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{service-name=\"test-repose\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{token=\"mytoken\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-constant})
        }
      end

      context 'providing constant sampling - off' do
        let(:title) { 'constant_sampling_off' }
        let(:params) do
          {
            ensure: 'present',
            service_name: 'test-repose',
            http_connection_token: 'mytoken',
            http_connection_endpoint: 'http://example.com/api/traces',
            constant_toggle: 'off',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{connection-http endpoint=\"http:\/\/example.com\/api\/traces\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{service-name=\"test-repose\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{token=\"mytoken\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-constant toggle=\"off\"})
        }
      end

      context 'providing rate limiting sampling - set' do
        let(:title) { 'rate_limiting_sampling_set' }
        let(:params) do
          {
            ensure: 'present',
            service_name: 'test-repose',
            http_connection_token: 'mytoken',
            http_connection_endpoint: 'http://example.com/api/traces',
            rate_limiting_max_traces_per_second: 5.6,
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{connection-http endpoint=\"http:\/\/example.com\/api\/traces\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{service-name=\"test-repose\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{token=\"mytoken\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-rate-limiting max-traces-per-second=\"5.6\"})
        }
      end

      context 'providing probabilistic sampling - set' do
        let(:title) { 'probabilistic_sampling_set' }
        let(:params) do
          {
            ensure: 'present',
            service_name: 'test-repose',
            http_connection_token: 'mytoken',
            http_connection_endpoint: 'http://example.com/api/traces',
            probability: 1.0,
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660',
          )
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{connection-http endpoint=\"http:\/\/example.com\/api\/traces\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{service-name=\"test-repose\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{token=\"mytoken\"})
        }
        it {
          is_expected.to contain_file('/etc/repose/open-tracing.cfg.xml').with_content(%r{<sampling-probabilistic probability=\"1.0\"})
        }
      end

      context 'validate entries' do
        context 'validate connection_endpoint' do
          let(:title) { 'validate_connection_endpoint' }

          let(:params) do
            {
              ensure: 'present',
              service_name: 'test-repose',
              http_connection_endpoint: 'random',
            }
          end

          it {
            is_expected.to raise_error(Puppet::Error, %r{parameter 'http_connection_endpoint' expects a match for Stdlib::HTTPUrl})
          }
        end

        context 'validate connection_host only' do
          let(:title) { 'validate_connection_host_only' }

          let(:params) do
            {
              ensure: 'present',
              service_name: 'test-repose',
              udp_connection_host: 'localhost',
            }
          end

          it {
            is_expected.to raise_error(/one of sampling parameters must be defined/)
          }
        end

        context 'validate connection_port only' do
          let(:title) { 'validate_connection_port_only' }

          let(:params) do
            {
              ensure: 'present',
              service_name: 'test-repose',
              udp_connection_port: 5755,
            }
          end

          it {
            is_expected.to raise_error(/one of sampling parameters must be defined/)
          }
        end

        context 'validate connection_host invalid' do
          let(:title) { 'validate_connection_host_invalid' }

          let(:params) do
            {
              ensure: 'present',
              service_name: 'test-repose',
              udp_connection_port: 5775,
              udp_connection_host: 'this~is{bad',
            }
          end

          it {
            is_expected.to raise_error(/parameter 'udp_connection_host' expects a Stdlib::Host/)
          }
        end

        # context 'validate connection_host invalid ipv4' do
        #   let(:title) { 'validate_connection_host_ipv4' }

        #   let(:params) do
        #     {
        #       ensure: 'present',
        #       service_name: 'test-repose',
        #       udp_connection_port: 5775,
        #       udp_connection_host: '127.0.0',
        #       constant_toggle: 'off',
        #     }
        #   end

        #   it {
        #     is_expected.to raise_error(/parameter 'udp_connection_host' expects a Stdlib::Host/)
        #   }
        # end

        context 'validate connection_host invalid ipv6' do
          let(:title) { 'validate_connection_host_ipv6' }

          let(:params) do
            {
              ensure: 'present',
              service_name: 'test-repose',
              udp_connection_port: 5775,
              udp_connection_host: '2001:0db8:85a3:0000:0000:8a2e:x:5',
            }
          end

          it {
            is_expected.to raise_error(/parameter 'udp_connection_host' expects a Stdlib::Host/)
          }
        end
      end
    end
  end
end
