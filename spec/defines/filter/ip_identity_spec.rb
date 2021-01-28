require 'spec_helper'
describe 'repose::filter::ip_identity', :type => :define do
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
          should raise_error(Puppet::Error,/expects a value for parameter 'whitelist'/)
        }
      end

      context 'with ensure absent' do
        let(:title) { 'default' }
        let(:params) { {
          :ensure => 'absent',
          :whitelist => { }
        } }
        it {
          should contain_file('/etc/repose/ip-identity.cfg.xml').with_ensure(
            'absent')
        }
      end

      context 'providing a whitelist' do
        let(:title) { 'whitelist' }
        let(:params) { {
          :ensure    => 'present',
          :filename  => 'ip-identity.cfg.xml',
          :quality   => '0.25',
          :whitelist => {
            'quality'   => '0.3',
            'addresses' => [ '9.9.9.9', ],
          }
        } }
        it {
          should contain_file('/etc/repose/ip-identity.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/<quality>0.25<\/quality>/).
            with_content(/<white-list quality=\"0\.3\">/).
            with_content(/<ip-address>9\.9\.9\.9<\/ip-address>/)
        }
      end
    end
  end
end