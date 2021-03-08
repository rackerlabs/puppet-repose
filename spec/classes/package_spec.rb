require 'spec_helper'
describe 'repose::package' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end

      it { is_expected.to compile.with_all_deps }
      # the defaults for the package class should
      # 1) install the package
      context 'with defaults for all parameters' do
        it { is_expected.to contain_package('repose').with_ensure('present') }
        it { is_expected.to contain_package('repose-filter-bundle').with_ensure('present') }
        it { is_expected.to contain_package('repose-extensions-filter-bundle').with_ensure('present') }
      end

      # specifying a version for the package class should
      # 1) install the package to a specific version
      context 'with package version' do
        let(:params) do
          {
            ensure: '9.1.0.0',
          }
        end

        it { is_expected.to contain_package('repose').with_ensure('9.1.0.0') }
        it { is_expected.to contain_package('repose-filter-bundle').with_ensure('9.1.0.0') }
        it { is_expected.to contain_package('repose-extensions-filter-bundle').with_ensure('9.1.0.0') }
      end

      # specifying autoupgrade is true for the package class should
      # 1) set the packages to latest
      context 'with autoupgrade true' do
        let(:params) do
          {
            autoupgrade: true,
          }
        end

        it { is_expected.to contain_package('repose').with_ensure('latest') }
        it { is_expected.to contain_package('repose-filter-bundle').with_ensure('latest') }
        it { is_expected.to contain_package('repose-extensions-filter-bundle').with_ensure('latest') }
      end

      # Validate uninstall properly purged packages
      context 'uninstall parameters' do
        let(:params) { { ensure: 'absent' } }

        it { is_expected.to contain_package('repose').with_ensure('purged') }
        it { is_expected.to contain_package('repose-filter-bundle').with_ensure('purged') }
        it { is_expected.to contain_package('repose-extensions-filter-bundle').with_ensure('purged') }
      end

      # the defaults for the package class should
      # 1) install the package
      context 'with defaults+newpackages for all parameters' do
        it { is_expected.to contain_package('repose').with_ensure('present') }
        it { is_expected.to contain_package('repose-filter-bundle').with_ensure('present') }
        it { is_expected.to contain_package('repose-extensions-filter-bundle').with_ensure('present') }
      end

      # specifying a version for the package class should
      # 1) install the package to a specific version
      context 'with package version+newpackages' do
        let(:params) do
          {
            ensure: '9.1.0.0',
          }
        end

        it { is_expected.to contain_package('repose').with_ensure('9.1.0.0') }
        it { is_expected.to contain_package('repose-filter-bundle').with_ensure('9.1.0.0') }
        it { is_expected.to contain_package('repose-extensions-filter-bundle').with_ensure('9.1.0.0') }
      end

      # specifying autoupgrade is true for the package class should
      # 1) set the packages to latest
      context 'with autoupgrade true' do
        let(:params) do
          {
            autoupgrade: true,
          }
        end

        it { is_expected.to contain_package('repose').with_ensure('latest') }
        it { is_expected.to contain_package('repose-filter-bundle').with_ensure('latest') }
        it { is_expected.to contain_package('repose-extensions-filter-bundle').with_ensure('latest') }
      end

      # Validate uninstall properly purged packages
      context 'uninstall parameters' do
        let(:params) do
          {
            ensure: 'absent',
          }
        end

        it { is_expected.to contain_package('repose').with_ensure('purged') }
        it { is_expected.to contain_package('repose-filter-bundle').with_ensure('purged') }
        it { is_expected.to contain_package('repose-extensions-filter-bundle').with_ensure('purged') }
      end

      # the defaults for the package class + install experimental filter bundle
      context 'with defaults+newpackages for all parameters including experimental filter bundle' do
        let(:params) do
          {
            experimental_filters: true,
          }
        end

        it { is_expected.to contain_package('repose').with_ensure('present') }
        it { is_expected.to contain_package('repose-filter-bundle').with_ensure('present') }
        it { is_expected.to contain_package('repose-extensions-filter-bundle').with_ensure('present') }
        it { is_expected.to contain_package('repose-experimental-filter-bundle').with_ensure('present') }
      end

      # the defaults for the package class + install identity filter bundle
      context 'with defaults+newpackages for all parameters including identity filter bundle' do
        let(:params) do
          {
            identity_filters: true,
          }
        end

        it { is_expected.to contain_package('repose').with_ensure('present') }
        it { is_expected.to contain_package('repose-filter-bundle').with_ensure('present') }
        it { is_expected.to contain_package('repose-extensions-filter-bundle').with_ensure('present') }
        it { is_expected.to contain_package('repose-identity-filter-bundle').with_ensure('present') }
      end

      # Validate uninstall properly purged packages including experiemtnal bundle
      context 'uninstall parameters including experiemental filter bundle' do
        let(:params) do
          {
            ensure: 'absent',
            experimental_filters: true,
          }
        end

        it { is_expected.to contain_package('repose').with_ensure('purged') }
        it { is_expected.to contain_package('repose-filter-bundle').with_ensure('purged') }
        it { is_expected.to contain_package('repose-extensions-filter-bundle').with_ensure('purged') }
        it { is_expected.to contain_package('repose-experimental-filter-bundle').with_ensure('purged') }
      end

      # Validate uninstall properly purged packages including identity bundle
      context 'uninstall parameters including experiemental filter bundle' do
        let(:params) do
          {
            ensure: 'absent',
            identity_filters: true,
          }
        end

        it { is_expected.to contain_package('repose').with_ensure('purged') }
        it { is_expected.to contain_package('repose-filter-bundle').with_ensure('purged') }
        it { is_expected.to contain_package('repose-extensions-filter-bundle').with_ensure('purged') }
        it { is_expected.to contain_package('repose-identity-filter-bundle').with_ensure('purged') }
      end
    end
  end
end
