require 'spec_helper'
describe 'repose' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_class('repose') }
      it { is_expected.to contain_class('repose::package') }
      it { is_expected.to contain_class('repose::service') }
      it { is_expected.to contain_class('repose::config') }
      it { is_expected.to contain_class('repose::filter') }

      describe 'repose::package' do
        it { is_expected.to contain_package('repose').with_ensure('present') }
        it { is_expected.to contain_package('repose-filter-bundle').with_ensure('present') }
        it { is_expected.to contain_package('repose-extensions-filter-bundle').with_ensure('present') }
      end

      describe 'repose::config' do
        context 'with defaults for all parameters' do
          it {
            is_expected.to contain_file('/etc/sysconfig/repose').with(
              'ensure' => 'file',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => '0660',
            )
          }
          it {
            is_expected.to contain_file('/etc/security/limits.d/repose').with(
              'ensure' => 'file',
              'owner'  => 'repose',
              'group'  => 'repose',
              'mode'   => '0660',
            )
          }
          it {
            is_expected.to contain_augeas('repose_sysconfig').with_context(
              '/files/etc/sysconfig/repose',
            )
          }
          it {
            is_expected.to contain_augeas('repose_sysconfig')
              .with_changes([
                              [
                                "set JAVA_CMD '/usr/bin/java'",
                                "set REPOSE_CFG '/etc/repose'",
                                "set REPOSE_JAR '/usr/share/repose/repose.jar'",
                                "set DAEMON_HOME '/usr/share/repose'",
                                "set LOG_PATH '/var/log/repose'",
                                "set USER 'repose'",
                                "set daemonize '/usr/sbin/daemonize'",
                                "set daemonize_opts '\"-c $DAEMON_HOME -p $PID_FILE -u $USER -o $LOG_PATH/stdout.log -e $LOG_PATH/stderr.log -l /var/lock/subsys/$NAME\"'",
                                "set JAVA_OPTS '\"\"'",
                              ],
                              'rm SAXON_HOME',
                            ])
          }
          it {
            is_expected.to contain_augeas('repose_service_unit')
              .with_context('/files/lib/systemd/system/repose.service')
              .with_changes([
                              'rm /files/lib/systemd/system/repose.service/Service/Environment',
                              'set Service/EnvironmentFile/value /etc/sysconfig/repose',
                            ])
          }
        end
      end
      describe 'repose::service' do
        context 'with defaults for all parameters' do
          it {
            is_expected.to contain_service('repose').with_ensure('running')
          }
        end

        # Validate ensure is absent properly stops services
        context 'ensure is absent' do
          let(:params) { { ensure: 'absent' } }

          it {
            is_expected.to contain_service('repose').with_ensure('stopped')
          }
        end

        # Validate systemd dropin file
        context 'ensure systemd dropin file' do
          let(:params) do
            {
              content: '[Service]
    Environment="JAVA_OPTS=-javaagent:/opt/newrelic/newrelic.jar -Dnewrelic.config.file=/etc/newrelic/cidm_repose.yml -Xms4096m -Xmx4096m -XX:MaxPermSize=512m"',
            }
          end

          it {
            is_expected.to contain_file('/etc/systemd/system/repose.service.d/repose-local.conf').with(
              'content' => '[Service]
    Environment="JAVA_OPTS=-javaagent:/opt/newrelic/newrelic.jar -Dnewrelic.config.file=/etc/newrelic/cidm_repose.yml -Xms4096m -Xmx4096m -XX:MaxPermSize=512m"',
            )
          }
        end
      end
    end
  end
end
