require 'spec_helper'
describe 'repose::filter::CHANGEME', :type => :define do
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


    context 'default parameters' do
      let(:title) { 'default' }
      it {
        expect { 
          should compile
        }.to raise_error(Puppet::Error, /is a required/)
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
      } }
      it {
        should contain_file('/etc/repose/CHANGEME.cfg.xml').with_ensure(
          'absent')
      }
    end
    context 'providing a validator' do
      let(:title) { 'validator' }
      let(:params) { { 
        :ensure     => 'present',
        :filename   => 'CHANGEME.cfg.xml',
      } }
      it { 
        should contain_file('/etc/repose/CHANGEME.cfg.xml')
      }
    end
  end
end
