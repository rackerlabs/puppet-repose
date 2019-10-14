require 'spec_helper'
describe 'repose::repose9' do
  context 'on RedHat' do
    let :facts do
    {
      :osfamily               => 'RedHat',
      :operationsystemrelease => '6',
    }
    end

    context 'with defaults for all parameters' do
      let(:facts) { { :osfamily => 'RedHat' } }
      it {
        should contain_class('repose').with(
          'ensure'      => 'present',
          'enable'      => 'true',
          'autoupgrade' => 'false',
          'container'   => 'repose9'
        )
        should contain_file('/etc/sysconfig/repose')
        # TODO: add additional details here
        should contain_augeas('repose_sysconfig').with_context(
          '/files/etc/sysconfig/repose')
        should contain_augeas('repose_sysconfig').with_changes([
          [
          "set RUN_PORT '9090'",
          "set DAEMON_HOME '/usr/share/lib/repose'",
          "set LOG_PATH '/var/log/repose'",
          "set PID_FILE '/var/run/repose-valve.pid'",
          "set USER 'repose'",
          "set daemonize '/usr/sbin/daemonize'",
          "set daemonize_opts '\"-c $DAEMON_HOME -p $PID_FILE -u $USER -o $LOG_PATH/stdout.log -e $LOG_PATH/stderr.log -l /var/lock/subsys/$NAME\"'",
          "set run_opts '\"-p $RUN_PORT -c $CONFIG_DIRECTORY\"'",
          "set java_opts '\"${java_opts} \"'",
          "set JAVA_OPTS '\"${JAVA_OPTS} \"'"
          ],
          "rm SAXON_HOME"
        ])
      }
    end

    context 'with ensure absent' do
      let(:facts) { { :osfamily => 'RedHat' } }
      let(:params) { {
        :ensure => 'absent'
      } }
      it {
        should contain_class('repose').with(
          'ensure'      => 'absent',
          'enable'      => 'true',
          'autoupgrade' => 'false',
          'container'   => 'repose9'
        )
        should contain_file('/etc/sysconfig/repose').with_ensure('absent')
        should_not contain_augeas('repose_sysconfig')
      }
    end

    context 'with new packages' do
      let(:params) { { :rh_old_packages => 'false' } }
      it {
        should contain_class('repose').with(
          'ensure'          => 'present',
          'enable'          => 'true',
          'autoupgrade'     => 'false',
          'rh_old_packages' => 'false',
          'container'       => 'repose9'
        )
      }
    end

    context 'with new namespaces' do
      let(:params) { { :cfg_new_namespace => 'true' } }
      it {
        should contain_class('repose').with(
          'ensure'            => 'present',
          'enable'            => 'true',
          'autoupgrade'       => 'false',
          'rh_old_packages'   => 'true',
          'cfg_new_namespace' => 'true',
          'container'         => 'repose9'
        )
      }
    end

  end
end
