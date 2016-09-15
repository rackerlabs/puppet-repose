require 'spec_helper'
describe 'repose::filter::cors', :type => :define do
  let :pre_condition do
    'include repose'
  end
  context 'on RedHat' do
    let :facts do
    {
      :osfamily               => 'RedHat',
      :operationsystemrelease => '6',
    }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
      } }
      it {
        should contain_file('/etc/repose/cors.cfg.xml').with_ensure(
          'absent')
      }
    end

    context 'providing a validator' do
      let(:title) { 'validator' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'cors.cfg.xml',
        :allowed_origins      => { 10 => { 'is_regex' => 'true', 'origin' => '.*' },
        :allowed_methods => [ ],
        :resources       => { },
      } }
      it {
        should contain_file('/etc/repose/cors.cfg.xml').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose',
          'mode'   => '0660').
          with_content(/<origin regex=\"true\">\.\*\<\/origin\>/)
      } }
    end
  end
end
