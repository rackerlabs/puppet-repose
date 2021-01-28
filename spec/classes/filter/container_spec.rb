require 'spec_helper'
describe 'repose::filter::container' do
  let :pre_condition do
    'class {"repose": }'
  end
  
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end

      context 'with ensure absent' do
        let(:title) { 'default' }
        let(:params) { {
          :ensure => 'absent'
        } }
        it { should contain_file('/etc/repose/log4j.properties').with_ensure(
            'absent') }
        it { should contain_file('/etc/repose/container.cfg.xml').with_ensure( 
            'absent') }

      end

      context 'with defaults' do
        let(:params) { {
        } }
        it { should contain_file('/etc/repose/log4j.properties').
            with_content(/log4j\.rootLogger=WARN/).
            with_content(/log4j\.appender\.defaultFile\.File=\/var\/log\/repose\/repose\.log/) }
        it { should contain_file('/etc/repose/container.cfg.xml') 
        }
      end

      context 'configure logging' do
        let(:params) { {
          :log_dir         => '/mypath',
          :log_level       => 'DEBUG',
          :syslog_server   => 'syslog.example.com',
          :syslog_port     => 515,
          :syslog_protocol => 'tcp'
        } }
        it { should contain_file('/etc/repose/log4j.properties').
            with_content(/log4j\.appender\.defaultFile\.File=\/mypath\/repose\.log/).
            with_content(/log4j\.rootLogger=DEBUG, syslog, defaultFile/).
            with_content(/log4j.logger.http=INFO, httpSyslog/).
            with_content(/syslog.syslogHost=syslog.example.com/).
            with_content(/syslog.port=515/).
            with_content(/syslog.protocol=tcp/).
            with_content(/httpSyslog.syslogHost=syslog.example.com/).
            with_content(/httpSyslog.port=515/).
            with_content(/httpSyslog.protocol=tcp/) }
        it { should contain_file('/etc/repose/container.cfg.xml') 
        }
      end

      context 'configure container' do
        let(:params) { {
          :deployment_directory              => '/deployment_dir',
          :deployment_directory_auto_clean   => 'false',
          :artifact_directory                => '/artifact_dir',
          :artifact_directory_check_interval => '10000',
          :logging_configuration             => 'mylog4j.properties',
          :ssl_enabled                       => true,
          :ssl_keystore_filename             => 'keystore.name',
          :ssl_keystore_password             => 'mypassword',
          :ssl_key_password                  => 'keypassword',
          :ssl_include_cipher                => ['include'],
          :ssl_exclude_cipher                => ['exclude'],
          :ssl_include_protocol              => ['include'],
          :ssl_exclude_protocol              => ['exclude'],
          :ssl_tls_renegotiation             => 'true',
          :content_body_read_limit           => '10240000',
          :jmx_reset_time                    => '3600000',
        } }
        it { should contain_file('/etc/repose/mylog4j.properties') }
        it { should contain_file('/etc/repose/container.cfg.xml'). 
            with_content(/jmx-reset-time="3600000"/).
            with_content(/<deployment-directory auto-clean=\"false\">\/deployment_dir<\/deployment-directory>/).
            with_content(/<artifact-directory check-interval="10000">\/artifact_dir<\/artifact-directory>/).
            with_content(/<logging-configuration href="mylog4j.properties"\/>/).
            with_content(/<ssl-configuration>/).
            with_content(/<keystore-filename>keystore.name<\/keystore-filename>/).
            with_content(/<keystore-password>mypassword<\/keystore-password>/).
            with_content(/<key-password>keypassword<\/key-password>/).
            with_content(/<included-ciphers>/).
            with_content(/<excluded-ciphers>/).
            with_content(/<included-protocols>/).
            with_content(/<excluded-protocols>/).
            with_content(/<tls-renegotiation-allowed>true<\/tls-renegotiation-allowed>/).
            with_content(/<\/ssl-configuration>/) }
      end

      context 'configure no logging' do
        let(:params) { {
          :log_dir          => '/mypath',
          :log_local_policy => false
        } }
        it { should contain_file('/etc/repose/log4j.properties'). 
            with_content(/log4j\.appender\.defaultFile=org\.apache\.log4j\.varia\.NullAppender/).
            with_content(/log4j\.rootLogger=WARN, defaultFile/).
            with_content(/log4j\.logger\.http=INFO, httpLocal/).
            with_content(/httpLocal=org\.apache\.log4j\.varia\.NullAppender/) }
        it { should contain_file('/etc/repose/container.cfg.xml') }
      end

      context 'configure access log local default settings' do
        let(:params) { {
          :log_dir         => '/mypath'
        } }
        it { should contain_file('/etc/repose/log4j.properties'). 
            with_content(/log4j\.appender\.defaultFile\.File=\/mypath\/repose\.log/).
            with_content(/log4j\.logger\.http=INFO, httpLocal/).
            with_content(/httpLocal=org\.apache\.log4j\.DailyRollingFileAppender/).
            with_content(/httpLocal.File=\/mypath\/http_repose\.log/) }
        it { should contain_file('/etc/repose/container.cfg.xml') }
      end

      context 'configure access log local rotation on size' do
        let(:params) { {
          :log_local_policy         => 'size',
          :log_local_size           => '50MB',
          :log_local_rotation_count => 2,
          :log_access_local_name    => 'repose_access'
        } }

        it { should contain_file('/etc/repose/log4j.properties'). 
            with_content(/log4j\.logger\.http=INFO, httpLocal/).
            with_content(/httpLocal=org\.apache\.log4j\.RollingFileAppender/).
            with_content(/httpLocal\.maxFileSize=50MB/).
            with_content(/httpLocal\.maxBackupIndex=2/).
            with_content(/httpLocal.File=\/var\/log\/repose\/repose_access\.log/) }
        it { should contain_file('/etc/repose/container.cfg.xml') }
      end

      context 'configure access log syslog only' do
        let(:params) { {
          :log_dir          => '/mypath',
          :log_level        => 'DEBUG',
          :syslog_server    => 'syslog.example.com',
          :syslog_port      => 515,
          :syslog_protocol  => 'tcp',
          :log_access_local => false
        } }
        it { should contain_file('/etc/repose/log4j.properties'). 
            with_content(/log4j\.appender\.defaultFile\.File=\/mypath\/repose\.log/).
            with_content(/log4j\.rootLogger=DEBUG, syslog, defaultFile/).
            with_content(/log4j.logger.http=INFO, httpSyslog$/).
            with_content(/syslog.syslogHost=syslog.example.com/).
            with_content(/syslog.port=515/).
            with_content(/syslog.protocol=tcp/).
            with_content(/httpSyslog.syslogHost=syslog.example.com/).
            with_content(/httpSyslog.port=515/).
            with_content(/httpSyslog.protocol=tcp/).
            with_content(/log4j.appender.httpSyslog.Facility=local1/).
            without_content(/log4j.appender.httpLocal.layout=org.apache.log4j.PatternLayout/) }
        it { should contain_file('/etc/repose/container.cfg.xml') }
      end

      context 'configure repose log to syslog and access to local' do
        let(:params) { {
          :log_dir          => '/mypath',
          :log_level        => 'DEBUG',
          :syslog_server    => 'syslog.example.com',
          :syslog_port      => 515,
          :syslog_protocol  => 'tcp',
          :log_access_syslog => false
        } }
        it { should contain_file('/etc/repose/log4j.properties'). 
            with_content(/log4j\.appender\.defaultFile\.File=\/mypath\/repose\.log/).
            with_content(/log4j\.rootLogger=DEBUG, syslog, defaultFile/).
            with_content(/syslog.syslogHost=syslog.example.com/).
            with_content(/syslog.port=515/).
            with_content(/syslog.protocol=tcp/).
            with_content(/log4j.logger.http=INFO, httpLocal/).
            without_content(/httpSyslog.syslogHost=syslog.example.com/).
            without_content(/httpSyslog.port=515/).
            without_content(/httpSyslog.protocol=tcp/).
            with_content(/httpLocal.File=\/mypath\/http_repose.log/).
            with_content(/log4j.appender.syslog.Facility=local0/) }
        it { should contain_file('/etc/repose/container.cfg.xml') }

      end

      context 'configure syslog facilities' do
        let(:params) { {
          :log_dir             => '/mypath',
          :log_level           => 'DEBUG',
          :syslog_server       => 'syslog.example.com',
          :log_access_syslog   => true,
          :log_access_facility => 'local3',
          :log_repose_facility => 'local4'
        } }
        it { should contain_file('/etc/repose/log4j.properties'). 
            with_content(/log4j\.appender\.defaultFile\.File=\/mypath\/repose\.log/).
            with_content(/log4j\.rootLogger=DEBUG, syslog, defaultFile/).
            with_content(/syslog.syslogHost=syslog.example.com/).
            with_content(/syslog.port=514/).
            with_content(/log4j.logger.http=INFO, httpSyslog, httpLocal/).
            with_content(/httpSyslog.syslogHost=syslog.example.com/).
            with_content(/httpSyslog.port=514/).
            with_content(/httpLocal.File=\/mypath\/http_repose.log/).
            with_content(/log4j.appender.syslog.Facility=local4/).
            with_content(/log4j.appender.httpSyslog.Facility=local3/) }
        it { should contain_file('/etc/repose/container.cfg.xml') }
      end

      context 'configure log4j2' do
        let(:params) { {
          :log_use_log4j2 => true
        } }
        it { should contain_file('/etc/repose/log4j2.xml'). 
            with_content(/RollingFile name="defaultFile"/).
            with_content(/filename="\/var\/log\/repose\/repose.log"/).
            with_content(/filePattern="\/var\/log\/repose\/repose.log.%d\{yyyy-MM-dd\}"/).
            with_content(/RollingFile name="httpLocal"/).
            with_content(/filename="\/var\/log\/repose\/http_repose.log"/).
            with_content(/filePattern="\/var\/log\/repose\/http_repose.log.%d\{yyyy-MM-dd\}"/).
            with_content(/Root level="WARN"/).
            with_content(/AppenderRef ref="defaultFile"/).
            with_content(/Logger name="http" level="info"/).
            with_content(/AppenderRef ref="httpLocal"/).
            with_content(/Logger name="intrafilter-logging" level="info"/).
            with_content(/Logger name="org.openrepose" level="info"/).
            with_content(/Logger name="org.apache.http.wire" level="off"/) }
        it { should contain_file('/etc/repose/container.cfg.xml'). 
            with_content(/logging-configuration href="file:\/\/\/etc\/repose\/log4j2.xml"/) }
      end

      context 'configure log4j2 log_local_policy is size' do
        let(:params) { {
          :log_use_log4j2   => true,
          :log_local_policy => 'size'
        } }
        it { should contain_file('/etc/repose/log4j2.xml'). 
            with_content(/RollingFile name="defaultFile"/).
            with_content(/filename="\/var\/log\/repose\/repose.log"/).
            with_content(/filePattern="\/var\/log\/repose\/repose.log.%i"/).
            with_content(/SizeBasedTriggeringPolicy size=\"100MB\"/).
            with_content(/DefaultRolloverStrategy max="4"/).
            with_content(/RollingFile name="httpLocal"/).
            with_content(/filename="\/var\/log\/repose\/http_repose.log"/).
            with_content(/filePattern="\/var\/log\/repose\/http_repose.log.%i"/).
            with_content(/Root level="WARN"/).
            with_content(/AppenderRef ref="defaultFile"/).
            with_content(/Logger name="http" level="info"/).
            with_content(/AppenderRef ref="httpLocal"/) }

        it { should contain_file('/etc/repose/container.cfg.xml'). 
            with_content(/logging-configuration href="file:\/\/\/etc\/repose\/log4j2.xml"/) }
      end

      context 'configure log4j2 without log_access_local' do
        let(:params) { {
          :log_use_log4j2   => true,
          :log_access_local => false
        } }
        it { should contain_file('/etc/repose/log4j2.xml'). 
            with_content(/RollingFile name="defaultFile"/).
            with_content(/filename="\/var\/log\/repose\/repose.log"/).
            with_content(/filePattern="\/var\/log\/repose\/repose.log.%d\{yyyy-MM-dd\}"/).
            without_content(/RollingFile name="httpLocal"/).
            with_content(/Root level="WARN"/).
            with_content(/AppenderRef ref="defaultFile"/).
            with_content(/Logger name="http" level="info"/).
            without_content(/AppenderRef ref="httpLocal"/) }

        it { should contain_file('/etc/repose/container.cfg.xml'). 
            with_content(/logging-configuration href="file:\/\/\/etc\/repose\/log4j2.xml"/) }

      end

      context 'configure log4j2 with syslog' do
        let(:params) { {
          :log_use_log4j2   => true,
          :syslog_server    => 'syslog.example.com',
          :syslog_port      => 515,
          :syslog_protocol  => 'tcp',

        } }
        it { should contain_file('/etc/repose/log4j2.xml'). 
            with_content(/RollingFile name="defaultFile"/).
            with_content(/Syslog name="syslog" format="RFC5424"/).
            with_content(/host="syslog.example.com"/).
            with_content(/port="515"/).
            with_content(/protocol="tcp"/).
            with_content(/facility="local0"/).
            with_content(/Syslog name="httpSyslog" format="RFC5424"/).
            with_content(/facility="local1"/).
            with_content(/Root level="WARN"/).
            with_content(/AppenderRef ref="defaultFile"/).
            with_content(/AppenderRef ref="syslog"/).
            with_content(/Logger name="http" level="info"/).
            with_content(/AppenderRef ref="httpLocal"/).
            with_content(/AppenderRef ref="httpSyslog"/) }

        it { should contain_file('/etc/repose/container.cfg.xml'). 
            with_content(/logging-configuration href="file:\/\/\/etc\/repose\/log4j2.xml"/) }
      end

      context 'configure log4j2 with null appender' do
        let(:params) { {
          :log_use_log4j2   => true,
          :log_local_policy => 'none'
        } }
        it { should contain_file('/etc/repose/log4j2.xml'). 
            with_content(/File name="defaultFile" filename="\/dev\/null"/).
            with_content(/File name="httpLocal" filename="\/dev\/null"/) }

        it { should contain_file('/etc/repose/container.cfg.xml'). 
            with_content(/logging-configuration href="file:\/\/\/etc\/repose\/log4j2.xml"/) }
      end

      context 'configure log4j2 with intrafilter trace logging true' do
        let(:params) { {
          :log_use_log4j2        => true,
          :log_intrafilter_trace => true
        } }
        it { should contain_file('/etc/repose/log4j2.xml'). 
            with_content(/RollingFile name="defaultFile"/).
            with_content(/filename="\/var\/log\/repose\/repose.log"/).
            with_content(/filePattern="\/var\/log\/repose\/repose.log.%d\{yyyy-MM-dd\}"/).
            with_content(/RollingFile name="httpLocal"/).
            with_content(/filename="\/var\/log\/repose\/http_repose.log"/).
            with_content(/filePattern="\/var\/log\/repose\/http_repose.log.%d\{yyyy-MM-dd\}"/).
            with_content(/Root level="WARN"/).
            with_content(/AppenderRef ref="defaultFile"/).
            with_content(/Logger name="http" level="info"/).
            with_content(/AppenderRef ref="httpLocal"/).
            with_content(/Logger name="intrafilter-logging" level="trace"/).
            with_content(/Logger name="org.openrepose" level="debug"/).
            with_content(/Logger name="org.apache.http.wire" level="trace"/) }

        it { should contain_file('/etc/repose/container.cfg.xml'). 
            with_content(/logging-configuration href="file:\/\/\/etc\/repose\/log4j2.xml"/) }
      end

      context 'define via_header option' do
        let(:params) { {
          :via_header => { 'response-header' => 'Salad', 'repose-version' => 'false' }
        } }
        it { should contain_file('/etc/repose/container.cfg.xml'). 
          with_content(/response-header="Salad"/).
          with_content(/repose-version="false"/)
        }
      end
    end
  end
end
