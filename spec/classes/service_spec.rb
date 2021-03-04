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

      # Validate ensure is absent properly stops services
      context 'ensure is absent' do
        let(:params) { { :ensure => 'absent' } }
        it {
          should contain_service('repose').with_ensure('stopped')
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
