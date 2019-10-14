require 'spec_helper'
describe 'repose::service' do
  context 'on RedHat' do
    let :facts do
    {
      :osfamily               => 'RedHat',
      :operationsystemrelease => '6',
    }
    end

    # the defaults for the service class should
    # 1) ensures the service is running
    context 'with defaults for all parameters' do
      it {
        should contain_service('repose-valve').with_ensure('running')
      }
    end

    # Validate ensure is absent properly stops services
    context 'ensure is absent' do
      let(:params) { { :ensure => 'absent' } }
      it {
        should contain_service('repose-valve').with_ensure('stopped')
      }
    end

    # TODO: this seems weird.
    # Validate ensure present but enable is false stopped service
    context 'ensure is present but enable is off' do
      let(:params) { { :ensure => 'absent', :enable => false } }
      it {
        should contain_service('repose-valve').with(
          'ensure' => 'stopped',
          'enable' => false)
      }
    end

    # Validate ensure present but enable is manual
    context 'ensure is present but enable is off' do
      let(:params) { { :ensure => 'absent', :enable => 'manual' } }
      it {
        should contain_service('repose-valve').with(
          'ensure' => 'stopped',
          'enable' => 'manual')
      }
    end

    # ensures the repose9 service is running
    context 'with repose9 container parameter' do
      let(:params) { { :container => 'repose9' } }
      it {
        should contain_service('repose').with_ensure('running')
      }
    end

    # Validate ensure is absent properly stops repose9 service
    context 'ensure is absent' do
      let(:params) { { 
          :ensure => 'absent',
          :container => 'repose9',
      } }
      it {
        should contain_service('repose').with_ensure('stopped')
      }
    end
  end
end
