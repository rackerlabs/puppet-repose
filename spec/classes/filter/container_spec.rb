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

    context 'configure no logging' do
      let(:params) { {
        :app_name         => 'app',
        :log_dir          => '/mypath',
        :log_local_policy => false
      } }
      it {
        should contain_file('/etc/repose/log4j.properties').
          with_content(/log4j\.appender\.defaultFile=org\.apache\.log4j\.varia\.NullAppender/).
          with_content(/log4j\.rootLogger=WARN, defaultFile/).
          with_content(/log4j\.logger\.http=INFO, httpLocal/).
          with_content(/httpLocal=org\.apache\.log4j\.varia\.NullAppender/)
        should contain_file('/etc/repose/container.cfg.xml')
      }
    end

    context 'configure access log local default settings' do
      let(:params) { {
        :app_name        => 'app',
        :log_dir         => '/mypath'
      } }
      it {
        should contain_file('/etc/repose/log4j.properties').
          with_content(/log4j\.appender\.defaultFile\.File=\/mypath\/app\.log/).
          with_content(/log4j\.logger\.http=INFO, httpLocal/).
          with_content(/httpLocal=org\.apache\.log4j\.DailyRollingFileAppender/).
          with_content(/httpLocal.File=\/mypath\/http_repose\.log/)
        should contain_file('/etc/repose/container.cfg.xml')
      }
    end

    context 'configure access log local rotation on size' do
      let(:params) { {
        :app_name                 => 'app',
        :log_local_policy         => 'size',
        :log_local_size           => '50M',
        :log_local_rotation_count => 2,
        :log_access_local_name    => 'repose_access'
      } }
      it {
        should contain_file('/etc/repose/log4j.properties').
          with_content(/log4j\.logger\.http=INFO, httpLocal/).
          with_content(/httpLocal=org\.apache\.log4j\.RollingFileAppender/).
          with_content(/httpLocal\.maxFileSize=50M/).
          with_content(/httpLocal\.maxBackupIndex=2/).
          with_content(/httpLocal.File=\/var\/log\/repose\/repose_access\.log/)
        should contain_file('/etc/repose/container.cfg.xml')
      }
    end

    context 'configure access log syslog only' do
      let(:params) { {
        :app_name         => 'app',
        :log_dir          => '/mypath',
        :log_level        => 'DEBUG',
        :syslog_server    => 'syslog.example.com',
        :syslog_port      => 515,
        :syslog_protocol  => 'tcp',
        :log_access_local => false
      } }
      it {
        should contain_file('/etc/repose/log4j.properties').
          with_content(/log4j\.appender\.defaultFile\.File=\/mypath\/app\.log/).
          with_content(/log4j\.rootLogger=DEBUG, syslog, defaultFile/).
          with_content(/log4j.logger.http=INFO, httpSyslog$/).
          with_content(/syslog.syslogHost=syslog.example.com/).
          with_content(/syslog.port=515/).
          with_content(/syslog.protocol=tcp/).
          with_content(/httpSyslog.syslogHost=syslog.example.com/).
          with_content(/httpSyslog.port=515/).
          with_content(/httpSyslog.protocol=tcp/).
          without_content(/log4j.appender.httpLocal.layout=org.apache.log4j.PatternLayout/)
        should contain_file('/etc/repose/container.cfg.xml')
      }
    end

    context 'configure repose log to syslog and access to local' do
      let(:params) { {
        :app_name         => 'app',
        :log_dir          => '/mypath',
        :log_level        => 'DEBUG',
        :syslog_server    => 'syslog.example.com',
        :syslog_port      => 515,
        :syslog_protocol  => 'tcp',
        :log_access_syslog => false
      } }
      it {
        should contain_file('/etc/repose/log4j.properties').
          with_content(/log4j\.appender\.defaultFile\.File=\/mypath\/app\.log/).
          with_content(/log4j\.rootLogger=DEBUG, syslog, defaultFile/).
          with_content(/syslog.syslogHost=syslog.example.com/).
          with_content(/syslog.port=515/).
          with_content(/syslog.protocol=tcp/).
          with_content(/log4j.logger.http=INFO, httpLocal/).
          without_content(/httpSyslog.syslogHost=syslog.example.com/).
          without_content(/httpSyslog.port=515/).
          without_content(/httpSyslog.protocol=tcp/).
          with_content(/httpLocal.File=\/mypath\/http_repose.log/)
        should contain_file('/etc/repose/container.cfg.xml')
      }
    end
  end
end
