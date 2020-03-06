require 'spec_helper'
describe 'repose' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end
        it { is_expected.to compile.with_all_deps }
      # the defaults for the init class should
      # 1) install the package
      # 2) configure repose to use the valve container
      # 3) drop a repose file in limits.d
      context 'with defaults for all parameters' do
        it { should contain_class('repose') }
        it { should contain_class('repose::package').with_ensure('present') }
        it { should contain_class('repose::service').with_ensure('present') }
        it { should contain_class('repose::config').with_ensure('present') }
        it { should contain_file('/etc/security/limits.d/repose').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose') }
      end

      # Validate specifying a version properly passes ensure = 9.1.0.0
      context 'with specific version' do
        let(:params) { { :ensure => '9.1.0.0' } }
        it { should contain_class('repose') }
        it { should contain_class('repose::package').with_ensure('9.1.0.0') }
        it { should contain_package('repose').with_ensure('9.1.0.0') }
        it { should contain_class('repose::service').with_ensure('9.1.0.0') }
        it { should contain_service('repose').with_ensure('running') }
        it { should contain_class('repose::config').with_ensure('9.1.0.0') }
      end

      # Validate uninstall properly passes ensure = absent around
      context 'uninstall parameters' do
        let(:params) { { :ensure => 'absent' } }
        it { should contain_class('repose') }
        it { should contain_class('repose::package').with_ensure('absent') }
        it { should contain_class('repose::service').with_ensure('absent') }
        it { should contain_class('repose::config').with_ensure('absent') }
        it { should contain_file('/etc/security/limits.d/repose').with(
            'ensure' => 'absent',
            'owner'  => 'repose',
            'group'  => 'repose') }
      end
    end
  end
end

