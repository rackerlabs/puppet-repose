require 'spec_helper'
describe 'repose::service' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end
      it { is_expected.to compile.with_all_deps }
      # the defaults for the service class should
      # 1) ensures the service is running
      context 'with defaults for all parameters' do
        it {
          should contain_service('repose').with_ensure('running')
        }
      end

      # Validate the service is running when 'ensure' is a version
      context 'ensure is a version' do
        let(:params) { { :ensure => '9.1.0.0' } }
        it {
          should contain_service('repose').with_ensure('running')
        }
      end

      # Validate ensure is absent properly stops services
      context 'ensure is absent' do
        let(:params) { { :ensure => 'absent' } }
        it {
          should contain_service('repose').with_ensure('stopped')
        }
      end

      # TODO: this seems weird.
      # Validate ensure present but enable is false stopped service
      context 'ensure is present but enable is off' do
        let(:params) { { :ensure => 'absent', :enable => false } }
        it {
          should contain_service('repose').with(
            'ensure' => 'stopped',
            'enable' => false)
        }
      end

      # Validate ensure present but enable is manual
      context 'ensure is present but enable is off' do
        let(:params) { { :ensure => 'absent', :enable => 'manual' } }
        it {
          should contain_service('repose').with(
            'ensure' => 'stopped',
            'enable' => 'manual')
        }
      end

      # Validate systemd dropin file
      context 'ensure systemd dropin file' do
        let(:params) { { 
          content: '[Service]
Environment="JAVA_OPTS=-javaagent:/opt/newrelic/newrelic.jar -Dnewrelic.config.file=/etc/newrelic/cidm_repose.yml -Xms4096m -Xmx4096m -XX:MaxPermSize=512m"
'
        }}
        it {
          should contain_file('/etc/systemd/system/repose.service.d/repose-local.conf').with(
            'content' => '[Service]
Environment="JAVA_OPTS=-javaagent:/opt/newrelic/newrelic.jar -Dnewrelic.config.file=/etc/newrelic/cidm_repose.yml -Xms4096m -Xmx4096m -XX:MaxPermSize=512m"
'
          )
        }
      end
    end
  end
end
