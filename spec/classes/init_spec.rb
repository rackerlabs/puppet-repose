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
        it { is_expected.to contain_class('repose') }
        it { is_expected.to contain_class('repose::package').with_ensure('present') }
        it { is_expected.to contain_class('repose::service').with_ensure('present') }
        it { is_expected.to contain_class('repose::config').with_ensure('present') }
        it { is_expected.to contain_class('repose::filter') }

      end

      # Validate uninstall properly passes ensure = absent around
      context 'uninstall parameters' do
        let(:params) { { ensure: 'absent' } }

        it { is_expected.to contain_class('repose') }
        it { is_expected.to contain_class('repose::package').with_ensure('absent') }
        it { is_expected.to contain_class('repose::service').with_ensure('absent') }
        it { is_expected.to contain_class('repose::config').with_ensure('absent') }
        it { is_expected.to contain_class('repose::filter') }
      end
    end
  end
end
