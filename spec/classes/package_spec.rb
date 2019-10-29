require 'spec_helper'
describe 'repose::package' do
  context 'on RedHat' do
    let :facts do
    {
      :osfamily               => 'RedHat',
      :operationsystemrelease => '6',
    }
    end

    # the defaults for the package class should
    # 1) install the package
    context 'with defaults for all parameters' do
      it {
        should contain_package('repose-valve').with_ensure('present')
        should contain_package('repose-filters').with_ensure('present')
        should contain_package('repose-extension-filters').with_ensure('present')
      }
    end

    # specifying a version for the package class should
    # 1) install the package to a specific version
    context 'with package version' do
      let(:params) { {
        :ensure => '6.1.1.1'
      } }
      it {
        should contain_package('repose-valve').with_ensure('6.1.1.1')
        should contain_package('repose-filters').with_ensure('6.1.1.1')
        should contain_package('repose-extension-filters').with_ensure('6.1.1.1')
      }
    end

    # specifying autoupgrade is true for the package class should
    # 1) set the packages to latest
    context 'with autoupgrade true' do
      let(:params) { {
        :autoupgrade => true
      } }
      it {
        should contain_package('repose-valve').with_ensure('latest')
        should contain_package('repose-filters').with_ensure('latest')
        should contain_package('repose-extension-filters').with_ensure('latest')
      }
    end

    # Validate uninstall properly purged packages
    context 'uninstall parameters' do
      let(:params) { { :ensure => 'absent' } }
      it {
        should contain_package('repose-valve').with_ensure('purged')
        should contain_package('repose-filters').with_ensure('purged')
        should contain_package('repose-extension-filters').with_ensure('purged')
      }
    end

    # the defaults for the package class should
    # 1) install the package
    context 'with defaults+newpackages for all parameters' do
      let(:params) { { :rh_old_packages => 'false' } }
      it {
        should contain_package('repose-valve').with_ensure('present')
        should contain_package('repose-filter-bundle').with_ensure('present')
        should contain_package('repose-extensions-filter-bundle').with_ensure('present')
      }
    end

    # specifying a version for the package class should
    # 1) install the package to a specific version
    context 'with package version+newpackages' do
      let(:params) { {
        :ensure          => '6.2.0.1',
        :rh_old_packages => 'false'
      } }
      it {
        should contain_package('repose-valve').with_ensure('6.2.0.1')
        should contain_package('repose-filter-bundle').with_ensure('6.2.0.1')
        should contain_package('repose-extensions-filter-bundle').with_ensure('6.2.0.1')
      }
    end

    # specifying autoupgrade is true for the package class should
    # 1) set the packages to latest
    context 'with autoupgrade true' do
      let(:params) { {
        :autoupgrade     => true,
        :rh_old_packages => 'false'
      } }
      it {
        should contain_package('repose-valve').with_ensure('latest')
        should contain_package('repose-filter-bundle').with_ensure('latest')
        should contain_package('repose-extensions-filter-bundle').with_ensure('latest')
      }
    end

    # Validate uninstall properly purged packages
    context 'uninstall parameters' do
      let(:params) { {
        :ensure          => 'absent',
        :rh_old_packages => 'false'
      } }
      it {
        should contain_package('repose-valve').with_ensure('purged')
        should contain_package('repose-filter-bundle').with_ensure('purged')
        should contain_package('repose-extensions-filter-bundle').with_ensure('purged')
      }
    end

    # the defaults for the package class + install experimental filter bundle
    context 'with defaults+newpackages for all parameters including experimental filter bundle' do
      let(:params) { { 
        :rh_old_packages => 'false',
        :experimental_filters => true
      } }
      it {
        should contain_package('repose-valve').with_ensure('present')
        should contain_package('repose-filter-bundle').with_ensure('present')
        should contain_package('repose-extensions-filter-bundle').with_ensure('present')
        should contain_package('repose-experimental-filter-bundle').with_ensure('present')
      }
    end

    # the defaults for the package class + install identity filter bundle
    context 'with defaults+newpackages for all parameters including identity filter bundle' do
      let(:params) { { 
        :rh_old_packages => 'false',
        :identity_filters => true
      } }
      it {
        should contain_package('repose-valve').with_ensure('present')
        should contain_package('repose-filter-bundle').with_ensure('present')
        should contain_package('repose-extensions-filter-bundle').with_ensure('present')
        should contain_package('repose-identity-filter-bundle').with_ensure('present')
      }
    end

    # Validate uninstall properly purged packages including experiemtnal bundle
    context 'uninstall parameters including experiemental filter bundle' do
      let(:params) { {
        :ensure               => 'absent',
        :rh_old_packages      => 'false',
        :experimental_filters => true
      } }
      it {
        should contain_package('repose-valve').with_ensure('purged')
        should contain_package('repose-filter-bundle').with_ensure('purged')
        should contain_package('repose-extensions-filter-bundle').with_ensure('purged')
        should contain_package('repose-experimental-filter-bundle').with_ensure('purged')
      }
    end

    # Validate uninstall properly purged packages including identity bundle
    context 'uninstall parameters including experiemental filter bundle' do
      let(:params) { {
        :ensure               => 'absent',
        :rh_old_packages      => 'false',
        :identity_filters     => true
      } }
      it {
        should contain_package('repose-valve').with_ensure('purged')
        should contain_package('repose-filter-bundle').with_ensure('purged')
        should contain_package('repose-extensions-filter-bundle').with_ensure('purged')
        should contain_package('repose-identity-filter-bundle').with_ensure('purged')
      }
    end
  end
end
