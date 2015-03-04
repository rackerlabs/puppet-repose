require 'spec_helper'
describe 'repose' do
  context 'on RedHat' do
    let :facts do
    {
      :osfamily               => 'RedHat',
      :operationsystemrelease => '6',
    }
    end

    # the defaults for the init class should
    # 1) install the package
    # 2) configure repose to use the valve container
    # 3) drop a repose file in limits.d
    context 'with defaults for all parameters' do
      it {
        should contain_class('repose')
        should contain_class('repose::package').with_ensure('present')
        should contain_class('repose::service').with_ensure('present')
        should contain_file('/etc/security/limits.d/repose').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose')
      }
    end

    # Validate specifying a version properly passes ensure = 6.1.1.1
    context 'with specific version' do
      let(:params) { { :ensure => '6.1.1.1' } }
      it {
        should contain_class('repose')
        should contain_class('repose::package').with_ensure('6.1.1.1')
        should contain_package('repose-valve').with_ensure('6.1.1.1')
        should contain_class('repose::service').with_ensure('6.1.1.1')
        should contain_service('repose-valve').with_ensure('running')
      }
    end

    # Validating that the old package names will be used
    context 'with specific version' do
      let(:params) { { :rh_old_packages => 'true' } }
      it {
        should contain_class('repose')
        should contain_class('repose::package').with(
          'rh_old_packages' => 'true')
        should contain_class('repose::service').with_ensure('present')
        should contain_file('/etc/security/limits.d/repose').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose')
      }
    end

    # Validating that the new package names will be used
    context 'with specific version' do
      let(:params) { { :rh_old_packages => 'false' } }
      it {
        should contain_class('repose')
        should contain_class('repose::package').with(
          'rh_old_packages' => 'false')
        should contain_class('repose::service').with_ensure('present')
        should contain_file('/etc/security/limits.d/repose').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose')
      }
    end

    # Validate uninstall properly passes ensure = absent around
    context 'uninstall parameters' do
      let(:params) { { :ensure => 'absent' } }
      it {
        should contain_class('repose')
        should contain_class('repose::package').with_ensure('absent')
        should contain_class('repose::service').with_ensure('absent')
        should contain_file('/etc/security/limits.d/repose').with(
          'ensure' => 'absent',
          'owner'  => 'repose',
          'group'  => 'repose')
      }
    end
  end
end
