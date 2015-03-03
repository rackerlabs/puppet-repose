require 'spec_helper'
describe 'repose::package' do
  context 'on RedHat' do
    let :facts do
    {
      :osfamily               => 'RedHat',
      :operationsystemrelease => '6',
    }
    end

    let(:pkg_names) {
      [
        'repose-valve',
        'repose-filter-bundle',
        'repose-extensions-filter-bundle'
      ]
    }

    # the defaults for the package class should
    # 1) install the package
    context 'with defaults for all parameters' do
      it {
        pkg_names.each do |pkg|
          should contain_package(pkg).with_ensure('present')
        end
        should contain_package('repose-valve').with_ensure('present')
        should contain_package('repose-filter-bundle').with_ensure('present')
        should contain_package('repose-extensions-filter-bundle').with_ensure('present')
      }
    end

    # specifying a version for the package class should
    # 1) install the package to a specific version
    context 'with package version' do
      let(:params) { {
        :ensure => '7.0.0.1'
      } }
      it {
        pkg_names.each do |pkg|
          should contain_package(pkg).with_ensure(params[:ensure])
        end
      }
    end

    # specifying autoupgrade is true for the package class should
    # 1) set the packages to latest
    context 'with autoupgrade true' do
      let(:params) { {
        :autoupgrade => true
      } }
      it {
        pkg_names.each do |pkg|
          should contain_package(pkg).with_ensure('latest')
        end
      }
    end

    # Validate uninstall properly purged packages
    context 'uninstall parameters' do
      let(:params) { { :ensure => 'absent' } }
      it {
        pkg_names.each do |pkg|
          should contain_package(pkg).with_ensure('purged')
        end
      }
    end
  end
end
