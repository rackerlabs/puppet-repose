require 'spec_helper'
describe 'repose::filter::ip_identity', :type => :define do
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
        should raise_error(Puppet::Error,/whitelist is a required parameter/)
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
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

    context 'with defaults with old namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => false }"
      end

      let(:title) { 'default' }
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
        should contain_file('/etc/repose/ip-identity.cfg.xml').
          with_content(/docs.rackspacecloud.com/)
      }
    end

    context 'with defaults with new namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => true }"
      end

      let(:title) { 'default' }
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
        should contain_file('/etc/repose/ip-identity.cfg.xml').
          with_content(/docs.openrepose.org/)
      }
    end
  end
end
