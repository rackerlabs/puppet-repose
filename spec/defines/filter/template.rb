require 'spec_helper'
describe 'repose::filter::CHANGEME', :type => :define do
  let :pre_condition do
    'include repose'
  end
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end


      context 'default parameters' do
        let(:title) { 'default' }
        it {
          should raise_error(Puppet::Error, /expects a value for parameter 'filename'/)
        }
      end

      context 'with ensure absent' do
        let(:title) { 'default' }
        let(:params) { {
          :ensure => 'absent',
          :filename   => 'CHANGEME.cfg.xml',
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
end