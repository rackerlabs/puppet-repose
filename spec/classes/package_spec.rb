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

    # Validate uninstall properly purged packages
    context 'uninstall parameters' do
      let(:params) { { :ensure => 'absent' } }
      it {
        should contain_package('repose-valve').with_ensure('purged')
        should contain_package('repose-filters').with_ensure('purged')
        should contain_package('repose-extension-filters').with_ensure('purged')
      }
    end
  end
end
