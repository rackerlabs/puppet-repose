require 'spec_helper'
describe 'repose::filter::http_connection_pool', :type => :class do
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

    context 'with defaults for all parameters' do
      it {
        should contain_file('/etc/repose/http-connection-pool.cfg.xml').
          with_content(/id="default"/).
          with_content(/default="true"/).
          with_content(/http.conn-manager.max-total="200"/).
          with_content(/http.conn-manager.max-per-route="20"/).
          with_content(/http.socket.timeout="30000"/).
          with_content(/http.socket.buffer-size="8192"/).
          with_content(/http.connection.timeout="30000"/).
          with_content(/http.connection.max-line-length="8192"/).
          with_content(/http.connection.max-header-count="100"/).
          with_content(/http.connection.max-status-line-garbage="100"/).
          with_content(/http.tcp.nodelay="true"/).
          with_content(/keepalive.timeout="0"/)
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
      } }
      it {
        should contain_file('/etc/repose/http-connection-pool.cfg.xml').with_ensure(
          'absent')
      }
    end

    context 'with additional pool' do
      let(:params) { {
        :additional_pools => [ {
           "id"                           => 'client-auth-pool',
           "is_default"                   => false,
           "conn_manager_max_total"       => 201,
           "conn_manager_max_per_route"   => 101,
           "socket_timeout"               => 30001,
           "socket_buffer_size"           => 8193,
           "conn_timeout"                 => 30001,
           "conn_max_line_length"         => 8193,
           "conn_max_header_count"        => 101,
           "conn_max_status_line_garbage" => 101,
           "tcp_nodelay"                  => false,
           "keepalive_timeout"            => 10000, }, ]
      } }
      it {
        should contain_file('/etc/repose/http-connection-pool.cfg.xml').
          with_content(/id="default"/).
          with_content(/default="true"/).
          with_content(/http.conn-manager.max-total="200"/).
          with_content(/http.conn-manager.max-per-route="20"/).
          with_content(/http.socket.timeout="30000"/).
          with_content(/http.socket.buffer-size="8192"/).
          with_content(/http.connection.timeout="30000"/).
          with_content(/http.connection.max-line-length="8192"/).
          with_content(/http.connection.max-header-count="100"/).
          with_content(/http.connection.max-status-line-garbage="100"/).
          with_content(/http.tcp.nodelay="true"/).
          with_content(/keepalive.timeout="0"/).
          with_content(/id="client-auth-pool"/).
          with_content(/default="false"/).
          with_content(/http.conn-manager.max-total="201"/).
          with_content(/http.conn-manager.max-per-route="101"/).
          with_content(/http.socket.timeout="30001"/).
          with_content(/http.socket.buffer-size="8193"/).
          with_content(/http.connection.timeout="30001"/).
          with_content(/http.connection.max-line-length="8193"/).
          with_content(/http.connection.max-header-count="101"/).
          with_content(/http.connection.max-status-line-garbage="101"/).
          with_content(/http.tcp.nodelay="false"/).
          with_content(/keepalive.timeout="10000"/
        )
      }
    end
  end
end
