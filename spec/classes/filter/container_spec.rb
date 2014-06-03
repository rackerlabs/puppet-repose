require 'spec_helper'
describe 'repose::filter::container' do
  context 'on RedHat' do
    let :facts do 
    {
      :osfamily               => 'RedHat',
      :operationsystemrelease => '6',
    }
    end

    context 'with defaults for all parameters' do
      it {
        expect { 
          should compile
        }.to raise_error(Puppet::Error, /app_name is a required parameter/)
      }
    end

    context 'with defaults with app_name' do
      let(:params) { { 
        :app_name => 'app'
      } }
      it { 
        should contain_file('/etc/repose/log4j.properties').
          with_content(/log4j\.rootLogger=WARN/).
          with_content(/log4j\.appender\.defaultFile\.File=\/var\/log\/repose\/app\.log/)
        should contain_file('/etc/repose/container.cfg.xml')
      }
    end

    context 'configure logging' do
      let(:params) { { 
        :app_name        => 'app',
        :log_dir         => '/mypath',
        :log_level       => 'DEBUG',
        :syslog_server   => 'syslog.example.com',
        :syslog_port     => 515,
        :syslog_protocol => 'tcp'
      } }
      it { 
        should contain_file('/etc/repose/log4j.properties').
          with_content(/log4j\.appender\.defaultFile\.File=\/mypath\/app\.log/).
          with_content(/log4j\.rootLogger=DEBUG, syslog, defaultFile/).
          with_content(/log4j.logger.http=INFO, httpSyslog/).
          with_content(/syslog.syslogHost=syslog.example.com/).
          with_content(/syslog.port=515/).
          with_content(/syslog.protocol=tcp/).
          with_content(/httpSyslog.syslogHost=syslog.example.com/).
          with_content(/httpSyslog.port=515/).
          with_content(/httpSyslog.protocol=tcp/)
        should contain_file('/etc/repose/container.cfg.xml')
      }
    end

    context 'configure container' do
      let(:params) { { 
        :app_name                          => 'app',
        :via                               => 'my app',
        :deployment_directory              => '/deployment_dir',
        :deployment_directory_auto_clean   => 'false',
        :artifact_directory                => '/artifact_dir',
        :artifact_directory_check_interval => '10000',
        :logging_configuration             => 'mylog4j.properties',
        :ssl_enabled                       => true,
        :ssl_keystore_filename             => 'keystore.name',
        :ssl_keystore_password             => 'mypassword',
        :ssl_key_password                  => 'keypassword',
        :content_body_read_limit           => '10240000',
        :jmx_reset_time                    => '3600000',
        :client_request_logging            => 'false',
        :http_port                         => '10000',
        :https_port                        => '10001',
        :connection_timeout                => '40000',
        :read_timeout                      => '1000',
        :proxy_thread_pool                 => 'my-pool'
      } }
      it { 
        should contain_file('/etc/repose/mylog4j.properties')
        should contain_file('/etc/repose/container.cfg.xml').
          with_content(/http-port="10000"/).
          with_content(/https-port="10001"/).
          with_content(/via="my app"/).
          with_content(/content-body-read-limit="10240000"/).
          with_content(/connection-timeout="40000"/).
          with_content(/read-timeout="1000"/).
          with_content(/proxy-thread-pool="my-pool"/).
          with_content(/client-request-logging="false"/).
          with_content(/jmx-reset-time="3600000"/).
          with_content(/<deployment-directory auto-clean=\"false\">\/deployment_dir<\/deployment-directory>/).
          with_content(/<artifact-directory check-interval="10000">\/artifact_dir<\/artifact-directory>/).
          with_content(/<logging-configuration href="mylog4j.properties"\/>/).
          with_content(/<ssl-configuration>/).
          with_content(/<keystore-filename>keystore.name<\/keystore-filename>/).
          with_content(/<keystore-password>mypassword<\/keystore-password>/).
          with_content(/<key-password>keypassword<\/key-password>/).
          with_content(/<\/ssl-configuration>/)
      }
    end

  end
end
