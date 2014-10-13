require 'spec_helper'
describe 'repose::valve' do
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
          'container'   => 'valve'
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
          "set java_opts '\"${java_opts} \"'"
          ],
          "rm SAXON_HOME"
        ])
      }
    end
  end
end
