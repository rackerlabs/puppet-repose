require 'spec_helper'
describe 'repose::tomcat7' do
  context 'on RedHat' do
    let :facts do
    {
      :osfamily               => 'RedHat',
      :operationsystemrelease => '6',
    }
    end

    context 'with defaults for all parameters' do
      it {
        should contain_class('repose').with(
          'ensure'          => 'present',
          'enable'          => 'true',
          'autoupgrade'     => 'false',
          'rh_old_packages' => 'true',
          'container'       => 'tomcat7'
        )
      }
    end

    context 'with new packages' do
      let(:params) { { :rh_old_packages => 'false' } }
      it {
        should contain_class('repose').with(
          'ensure'          => 'present',
          'enable'          => 'true',
          'autoupgrade'     => 'false',
          'rh_old_packages' => 'false',
          'container'       => 'tomcat7'
        )
      }
    end
  end
end
