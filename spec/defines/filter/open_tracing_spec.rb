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
        should raise_error(Puppet::Error, /either connection_http or connection_udp must be set/)
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

    context 'working parameters' do
      let(:title) { 'working' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
        :service_name => 'test-repose',
        :connection_http => {
          'endpoint' => 'http://example.com/api/traces'
        },
        :sampling_constant => {
          'toggle' => 'on'
        }
      } }
      it {
        should contain_file('/etc/repose/open-tracing.cfg.xml').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose',
          'mode'   => '0660').
          with_content(/connection-http endpoint=\"http:\/\/example.com\/api\/traces\"/).
          with_content(/service-name=\"test-repose\"/).
          with_content(/<sampling-constant toggle=\"on\"/)
      }
    end

    context 'providing http connection - no auth' do
      let(:title) { 'connection_http_no_auth' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
        :service_name => 'test-repose',
        :connection_http => {
          'endpoint' => 'http://example.com/api/traces'
        },
        :sampling_constant => {
          'toggle' => 'on'
        }
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
        :connection_http => {
          'endpoint' => 'http://example.com/api/traces',
          'username' => 'reposeuser'
        },
        :sampling_constant => {
          'toggle' => 'on'
        }
      } }
      it {
        should raise_error(Puppet::Error, /must define password since username is defined for connection_http/)
      }
    end

    context 'providing http connection - username + password' do
      let(:title) { 'connection_http_username_and_password' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
        :service_name => 'test-repose',
        :connection_http => {
          'endpoint' => 'http://example.com/api/traces',
          'username' => 'reposeuser',
          'password' => 'reposepass'
        },
        :sampling_constant => {
          'toggle' => 'on'
        }
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
        :connection_http => {
          'endpoint' => 'http://example.com/api/traces',
          'username' => 'reposeuser',
          'password' => 'reposepass',
          'token'    => 'mytoken'
        },
        :sampling_constant => {
          'toggle' => 'on'
        }
      } }
      it {
        should raise_error(Puppet::Error, /cannot define both token and username for connection_http/)
      }
    end

    context 'providing http connection - only token' do
      let(:title) { 'connection_http_only_token' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
        :service_name => 'test-repose',
        :connection_http => {
          'endpoint' => 'http://example.com/api/traces',
          'token'    => 'mytoken'
        },
        :sampling_constant => {
          'toggle' => 'on'
        }
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
        :connection_http => {
          'token'    => 'mytoken'
        },
        :sampling_constant => {
          'toggle' => 'on'
        }
      } }
      it {
        should raise_error(Puppet::Error, /must define http endpoint for connection_http/)
      }
    end

    context 'providing udp connection - default' do
      let(:title) { 'connection_udp_default' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
        :service_name => 'test-repose',
        :connection_udp => {},
        :sampling_constant => {
          'toggle' => 'on'
        }
      } }
      it {
        should raise_error(Puppet::Error, /must specify host and port for connection_udp/)
      }
    end

    context 'providing udp connection - only host' do
      let(:title) { 'connection_udp_only_host' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
        :service_name => 'test-repose',
        :connection_udp => {
          'host' => 'localhost'
        },
        :sampling_constant => {
          'toggle' => 'on'
        }
      } }
      it {
        should raise_error(Puppet::Error, /must specify host and port for connection_udp/)
      }
    end

    context 'providing no sampling algorithm' do
      let(:title) { 'no_sampling_algo' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
        :service_name => 'test-repose',
        :connection_udp => {
          'host' => 'localhost',
          'port' => 5755
        }
      } }
      it {
        should raise_error(Puppet::Error, /must define at a sampling algorithm/)
      }
    end

    context 'providing constant sampling - default' do
      let(:title) { 'constant_sampling_default' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
        :service_name => 'test-repose',
        :connection_http => {
          'endpoint' => 'http://example.com/api/traces',
          'token'    => 'mytoken'
        },
        :sampling_constant => {}
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
        :connection_http => {
          'endpoint' => 'http://example.com/api/traces',
          'token'    => 'mytoken'
        },
        :sampling_constant => {
          'toggle'   => 'off'
        }
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

    context 'providing rate limiting sampling - default' do
      let(:title) { 'rate_limiting_sampling_default' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
        :service_name => 'test-repose',
        :connection_http => {
          'endpoint' => 'http://example.com/api/traces',
          'token'    => 'mytoken'
        },
        :sampling_rate_limiting => {}
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
          with_content(/<sampling-rate-limiting/)
      }
    end

    context 'providing rate limiting sampling - set' do
      let(:title) { 'rate_limiting_sampling_set' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
        :service_name => 'test-repose',
        :connection_http => {
          'endpoint' => 'http://example.com/api/traces',
          'token'    => 'mytoken'
        },
        :sampling_rate_limiting => {
          'max_traces_per_second' => '5.6'
        }
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

    context 'providing probabilistic sampling - default' do
      let(:title) { 'probabilistic_sampling_default' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
        :service_name => 'test-repose',
        :connection_http => {
          'endpoint' => 'http://example.com/api/traces',
          'token'    => 'mytoken'
        },
        :sampling_probabilistic => {}
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
          with_content(/<sampling-probabilistic/)
      }
    end

    context 'providing probabilistic sampling - set' do
      let(:title) { 'probabilistic_sampling_set' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
        :service_name => 'test-repose',
        :connection_http => {
          'endpoint' => 'http://example.com/api/traces',
          'token'    => 'mytoken'
        },
        :sampling_probabilistic => {
          'probability' => '1.0'
        }
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

    context 'providing probabilistic and constant sampling' do
      let(:title) { 'probabilistic_sampling_default' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
        :service_name => 'test-repose',
        :connection_http => {
          'endpoint' => 'http://example.com/api/traces',
          'token'    => 'mytoken'
        },
        :sampling_probabilistic => {},
        :sampling_constant => {}
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

    context 'with defaults with old namespace' do
      let(:title) { 'old_namespace_default' }
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => false }"
      end

      let(:params) { {
        :ensure     => 'present',
        :filename   => 'open-tracing.cfg.xml',
        :service_name => 'test-repose',
        :connection_http => {
          'endpoint' => 'http://example.com/api/traces'
        },
        :sampling_constant => {
          'toggle' => 'on'
        }
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
        :connection_http => {
          'endpoint' => 'http://example.com/api/traces'
        },
        :sampling_constant => {
          'toggle' => 'on'
        }
      } }
      it {
        should contain_file('/etc/repose/open-tracing.cfg.xml').
          with_content(/docs.openrepose.org/)
      }
    end
  end
end
