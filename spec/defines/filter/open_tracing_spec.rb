require 'spec_helper'
describe 'repose::filter::open_tracing', :type => :define do
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
        should contain_file('/etc/repose/open-tracing.cfg.xml').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose',
          'mode'   => '0660').
          with_content(/connection-http endpoint=\"http:\/\/localhost:12682\/api\/traces\"/).
          with_content(/service-name=\"repose\"/).
          with_content(/<sampling-constant toggle=\"off\"/)
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
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
        :filename   => 'open-tracing.cfg.xml',
        :service_name => 'test-repose',
        :http_connection_endpoint => 'http://example.com/api/traces',
        :constant_toggle => 'on'
      } }
      it {
        should contain_file('/etc/repose/open-tracing.cfg.xml').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose',
          'mode'   => '0660').
          with_content(/connection-http endpoint=\"http:\/\/example.com\/api\/traces\"/).
          with_content(/service-name=\"test-repose\"/).
          with_content(/<sampling-constant/)
      }
    end

    context 'providing http connection - only username' do
      let(:title) { 'connection_http_only_username' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
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
        :filename   => 'open-tracing.cfg.xml',
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
          'mode'   => '0660').
          with_content(/connection-http endpoint=\"http:\/\/example.com\/api\/traces\"/).
          with_content(/username=\"reposeuser\"/).
          with_content(/password=\"reposepass\"/).
          with_content(/service-name=\"test-repose\"/).
          with_content(/<sampling-constant/)
    }
    end

    context 'providing http connection - username + password + token' do
      let(:title) { 'connection_http_username_and_password_and_token' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
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
        :filename   => 'open-tracing.cfg.xml',
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
          'mode'   => '0660').
          with_content(/connection-http endpoint=\"http:\/\/example.com\/api\/traces\"/).
          with_content(/service-name=\"test-repose\"/).
          with_content(/token=\"mytoken\"/).
          with_content(/<sampling-constant toggle=\"on\"/)
      }
    end

    context 'providing http connection - no endpoint' do
      let(:title) { 'connection_http_no_endpoint' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
        :service_name => 'test-repose',
        :http_connection_token    => 'mytoken',
        :constant_toggle => 'on'
      } }
      it {
        should contain_file('/etc/repose/open-tracing.cfg.xml').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose',
          'mode'   => '0660').
          with_content(/connection-http endpoint=\"http:\/\/localhost:12682\/api\/traces\"/).
          with_content(/token=\"mytoken\"/).
          with_content(/service-name=\"test-repose\"/).
          with_content(/<sampling-constant toggle=\"on\"/)
      }
    end

    context 'providing udp connection' do
      let(:title) { 'connection_udp' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
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
          'mode'   => '0660').
          with_content(/connection-udp port=\"5775\" host=\"newhost.example.com\" /).
          with_content(/service-name=\"test-repose\"/).
          with_content(/<sampling-constant toggle=\"on\"/)
      }
    end

    context 'providing udp connection - host IP4' do
      let(:title) { 'connection_udp_only_host' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
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
          'mode'   => '0660').
          with_content(/connection-udp port=\"5775\" host=\"127.0.0.1\" /).
          with_content(/service-name=\"test-repose\"/).
          with_content(/<sampling-constant toggle=\"on\"/)
      }
    end

    context 'providing udp connection - host IP6' do
      let(:title) { 'connection_udp_only_host' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
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
          'mode'   => '0660').
          with_content(/connection-udp port=\"5775\" host=\"2001:0db8:85a3:0000:0000:8a2e:0370:7334\" /).
          with_content(/service-name=\"test-repose\"/).
          with_content(/<sampling-constant toggle=\"on\"/)
      }
    end

    context 'providing constant sampling - default' do
      let(:title) { 'constant_sampling_default' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
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
          'mode'   => '0660').
          with_content(/connection-http endpoint=\"http:\/\/example.com\/api\/traces\"/).
          with_content(/service-name=\"test-repose\"/).
          with_content(/token=\"mytoken\"/).
          with_content(/<sampling-constant/)
      }
    end

    context 'providing constant sampling - off' do
      let(:title) { 'constant_sampling_off' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
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
          'mode'   => '0660').
          with_content(/connection-http endpoint=\"http:\/\/example.com\/api\/traces\"/).
          with_content(/service-name=\"test-repose\"/).
          with_content(/token=\"mytoken\"/).
          with_content(/<sampling-constant toggle=\"off\"/)
      }
    end

    context 'providing rate limiting sampling - set' do
      let(:title) { 'rate_limiting_sampling_set' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
        :service_name => 'test-repose',
        :http_connection_token    => 'mytoken',
        :http_connection_endpoint => 'http://example.com/api/traces',
        :rate_limiting_max_traces_per_second => '5.6'
      } }
      it {
        should contain_file('/etc/repose/open-tracing.cfg.xml').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose',
          'mode'   => '0660').
          with_content(/connection-http endpoint=\"http:\/\/example.com\/api\/traces\"/).
          with_content(/service-name=\"test-repose\"/).
          with_content(/token=\"mytoken\"/).
          with_content(/<sampling-rate-limiting max-traces-per-second=\"5.6\"/)
      }
    end

    context 'providing probabilistic sampling - set' do
      let(:title) { 'probabilistic_sampling_set' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
        :service_name => 'test-repose',
        :http_connection_token    => 'mytoken',
        :http_connection_endpoint => 'http://example.com/api/traces',
        :probability => '1.0'
      } }
      it {
        should contain_file('/etc/repose/open-tracing.cfg.xml').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose',
          'mode'   => '0660').
          with_content(/connection-http endpoint=\"http:\/\/example.com\/api\/traces\"/).
          with_content(/service-name=\"test-repose\"/).
          with_content(/token=\"mytoken\"/).
          with_content(/<sampling-probabilistic probability=\"1.0\"/)
      }
    end

    context 'with defaults with old namespace' do
      let(:title) { 'old_namespace_default' }
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => false }"
      end

      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
        :service_name => 'test-repose',
        :http_connection_token    => 'mytoken',
        :http_connection_endpoint => 'http://example.com/api/traces'
      } }
      it {
        should contain_file('/etc/repose/open-tracing.cfg.xml').
          with_content(/docs.rackspacecloud.com/)
      }
    end

    context 'with defaults with new namespace' do
      let(:title) { 'new_namespace_default' }
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => true }"
      end

      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
        :service_name => 'test-repose',
        :http_connection_token    => 'mytoken',
        :http_connection_endpoint => 'http://example.com/api/traces'
      } }
      it {
        should contain_file('/etc/repose/open-tracing.cfg.xml').
          with_content(/docs.openrepose.org/)
      }
    end

    context 'validate entries' do
      context 'validate connection_endpoint' do
        let(:title) { 'validate_connection_endpoint' }
  
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'open-tracing.cfg.xml',
          :service_name => 'test-repose',
          :http_connection_endpoint => 'random'
        } }
        it {
          should raise_error(Puppet::Error, /Must provide valid http:\/\/ endpoint for http_connection_endpoint/)
        }
      end

      context 'validate connection_username' do
        let(:title) { 'validate_connection_username' }
  
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'open-tracing.cfg.xml',
          :service_name => 'test-repose',
          :http_connection_username => true,
          :http_connection_password => 'reposepass',
        } }
        it {
          should raise_error(Puppet::Error, /true is not a string.  It looks to be a TrueClass/)
        }
      end

      context 'validate connection_password' do
        let(:title) { 'validate_connection_password' }
  
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'open-tracing.cfg.xml',
          :service_name => 'test-repose',
          :http_connection_username => 'test',
          :http_connection_password => true
        } }
        it {
          should raise_error(Puppet::Error, /true is not a string.  It looks to be a TrueClass/)
        }
      end

      context 'validate connection_token' do
        let(:title) { 'validate_connection_token' }
  
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'open-tracing.cfg.xml',
          :service_name => 'test-repose',
          :http_connection_token => true
        } }
        it {
          should raise_error(Puppet::Error, /true is not a string.  It looks to be a TrueClass/)
        }
      end

      context 'validate connection_host' do
        let(:title) { 'validate_connection_host' }
  
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'open-tracing.cfg.xml',
          :service_name => 'test-repose',
          :udp_connection_port => 5755,
          :udp_connection_host => ''
        } }
        it {
          should raise_error(Puppet::Error, /Must provide valid host for udp_connection_host/)
        }
      end

      context 'validate connection_host only' do
        let(:title) { 'validate_connection_host_only' }
  
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'open-tracing.cfg.xml',
          :service_name => 'test-repose',
          :udp_connection_host => 'localhost'
        } }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/connection-http endpoint=\"http:\/\/localhost:12682\/api\/traces\"/).
            with_content(/service-name=\"test-repose\"/).
            with_content(/<sampling-constant toggle=\"off\"/)
          }
      end

      context 'validate connection_port only' do
        let(:title) { 'validate_connection_port_only' }
  
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'open-tracing.cfg.xml',
          :service_name => 'test-repose',
          :udp_connection_port => 5755
        } }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/connection-http endpoint=\"http:\/\/localhost:12682\/api\/traces\"/).
            with_content(/service-name=\"test-repose\"/).
            with_content(/<sampling-constant toggle=\"off\"/)
          }
      end

      context 'validate connection_host invalid' do
        let(:title) { 'validate_connection_host_invalid' }
  
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'open-tracing.cfg.xml',
          :service_name => 'test-repose',
          :udp_connection_port => 5775,
          :udp_connection_host => 'this~is{bad'
        } }
        it {
          should raise_error(Puppet::Error, /Must provide valid host for udp_connection_host/)
        }
      end

      context 'validate connection_host invalid ipv4 - validates on hostname' do
        let(:title) { 'validate_connection_host_ipv4_validates_on_hostname' }
  
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'open-tracing.cfg.xml',
          :service_name => 'test-repose',
          :udp_connection_port => 5775,
          :udp_connection_host => '127.0.0'
        } }
        it {
          should contain_file('/etc/repose/open-tracing.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/connection-udp port=\"5775\" host=\"127.0.0\"/).
            with_content(/service-name=\"test-repose\"/).
            with_content(/<sampling-constant toggle=\"off\"/)
          }
      end

      context 'validate connection_host invalid ipv6' do
        let(:title) { 'validate_connection_host_ipv6' }
  
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'open-tracing.cfg.xml',
          :service_name => 'test-repose',
          :udp_connection_port => 5775,
          :udp_connection_host => '2001:0db8:85a3:0000:0000:8a2e:x:5'
        } }
        it {
          should raise_error(Puppet::Error, /Must provide valid host for udp_connection_host/)
        }
      end

      context 'validate connection_port' do
        let(:title) { 'validate_connection_port' }
  
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'open-tracing.cfg.xml',
          :service_name => 'test-repose',
          :udp_connection_host => 'localhost',
          :udp_connection_port => 'localhost'
        } }
        it {
          should raise_error(Puppet::Error, /connection_port must be an integer/)
        }
      end

      context 'validate constant_toggle' do
        let(:title) { 'validate_constant_toggle' }
  
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'open-tracing.cfg.xml',
          :service_name => 'test-repose',
          :constant_toggle => 'random'
        } }
        it {
          should raise_error(Puppet::Error, /constant_toggle must be set to on or off/)
        }
      end

      context 'validate max_traces_per_second' do
        let(:title) { 'validate_max_traces_per_second' }
  
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'open-tracing.cfg.xml',
          :service_name => 'test-repose',
          :rate_limiting_max_traces_per_second => 'random'
        } }
        it {
          should raise_error(Puppet::Error, /max_traces_per_second must be an float/)
        }
      end

      context 'validate probability' do
        let(:title) { 'validate_probability' }
  
        let(:params) { {
          :ensure     => 'present',
          :filename   => 'open-tracing.cfg.xml',
          :service_name => 'test-repose',
          :probability => 'random'
        } }
        it {
          should raise_error(Puppet::Error, /probability must be an float/)
        }
      end
    end
  end
end
