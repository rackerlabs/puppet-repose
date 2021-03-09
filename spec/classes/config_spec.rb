require 'spec_helper'
describe 'repose::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end

      it { is_expected.to compile.with_all_deps }
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
        # TODO: add additional details here
        it {
          is_expected.to contain_augeas('repose_sysconfig').with_context(
            '/files/etc/sysconfig/repose',
          )
        }
        it {
          is_expected.to contain_augeas('repose_sysconfig')
            .with_changes([
                            [
                              "set DAEMON_HOME '/usr/share/lib/repose'",
                              "set LOG_PATH '/var/log/repose'",
                              "set USER 'repose'",
                              "set daemonize '/usr/sbin/daemonize'",
                              "set daemonize_opts '\"-c $DAEMON_HOME -p $PID_FILE -u $USER -o $LOG_PATH/stdout.log -e $LOG_PATH/stderr.log -l /var/lock/subsys/$NAME\"'",
                              "set java_opts '\"${java_opts} \"'",
                              "set JAVA_OPTS '\"${JAVA_OPTS} \"'",
                            ],
                            'rm SAXON_HOME',
                          ])
        }
      end

      context 'with ensure absent' do
        let(:params) do
          {
            ensure: 'absent',
          }
        end

        it { is_expected.to contain_file('/etc/sysconfig/repose').with_ensure('absent') }
        it { is_expected.to contain_file('/etc/security/limits.d/repose').with_ensure('absent') }
        it { is_expected.not_to contain_augeas('repose_sysconfig') }
      end
    end
  end
end
