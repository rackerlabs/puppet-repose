require 'spec_helper'
describe 'repose::filter::http_connection_pool', type: :class do
  let :pre_condition do
    'include repose'
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end

      context 'with defaults for all parameters' do
        it {
          is_expected.to contain_file('/etc/repose/http-connection-pool.cfg.xml')
            .with_content(%r{id="default"})
            .with_content(%r{default="true"})
            .with_content(%r{http.conn-manager.max-total="200"})
            .with_content(%r{http.conn-manager.max-per-route="20"})
            .with_content(%r{http.socket.timeout="30000"})
            .with_content(%r{http.socket.buffer-size="8192"})
            .with_content(%r{http.connection.timeout="30000"})
            .with_content(%r{http.connection.max-line-length="8192"})
            .with_content(%r{http.connection.max-header-count="100"})
            .with_content(%r{http.connection.max-status-line-garbage="100"})
            .with_content(%r{http.tcp.nodelay="true"})
            .with_content(%r{keepalive.timeout="0"})
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
          is_expected.to contain_file('/etc/repose/http-connection-pool.cfg.xml').with_ensure(
            'absent',
          )
        }
      end

      context 'with additional pool' do
        let(:params) do
          {
            additional_pools: [{
              'id'                           => 'client-auth-pool',
              'is_default'                   => false,
              'conn_manager_max_total'       => 201,
              'conn_manager_max_per_route'   => 101,
              'socket_timeout'               => 30_001,
              'socket_buffer_size'           => 8193,
              'conn_timeout'                 => 30_001,
              'conn_max_line_length'         => 8193,
              'conn_max_header_count'        => 101,
              'conn_max_status_line_garbage' => 101,
              'tcp_nodelay'                  => false,
              'keepalive_timeout'            => 10_000,
            }],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/http-connection-pool.cfg.xml')
            .with_content(%r{id="default"})
            .with_content(%r{default="true"})
            .with_content(%r{http.conn-manager.max-total="200"})
            .with_content(%r{http.conn-manager.max-per-route="20"})
            .with_content(%r{http.socket.timeout="30000"})
            .with_content(%r{http.socket.buffer-size="8192"})
            .with_content(%r{http.connection.timeout="30000"})
            .with_content(%r{http.connection.max-line-length="8192"})
            .with_content(%r{http.connection.max-header-count="100"})
            .with_content(%r{http.connection.max-status-line-garbage="100"})
            .with_content(%r{http.tcp.nodelay="true"})
            .with_content(%r{keepalive.timeout="0"})
            .with_content(%r{id="client-auth-pool"})
            .with_content(%r{default="false"})
            .with_content(%r{http.conn-manager.max-total="201"})
            .with_content(%r{http.conn-manager.max-per-route="101"})
            .with_content(%r{http.socket.timeout="30001"})
            .with_content(%r{http.socket.buffer-size="8193"})
            .with_content(%r{http.connection.timeout="30001"})
            .with_content(%r{http.connection.max-line-length="8193"})
            .with_content(%r{http.connection.max-header-count="101"})
            .with_content(%r{http.connection.max-status-line-garbage="101"})
            .with_content(%r{http.tcp.nodelay="false"})
            .with_content(%r{keepalive.timeout="10000"})
        }
      end
    end
  end
end
