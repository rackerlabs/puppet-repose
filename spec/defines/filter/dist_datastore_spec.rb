require 'spec_helper'
describe 'repose::filter::dist_datastore', :type => :define do
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
        should raise_error(Puppet::Error,/nodes is a required parameter/)
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
      } }
      it {
        should contain_file('/etc/repose/dist-datastore.cfg.xml').with_ensure(
          'absent')
      }
    end

    context 'providing a validator' do
      let(:title) { 'validator' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'dist-datastore.cfg.xml',
        :nodes      => [ 'test.example.com', ]
      } }
      it {
        should contain_file('/etc/repose/dist-datastore.cfg.xml').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose',
          'mode'   => '0660').
          with_content(/<allow host=\"test\.example\.com\" \/>/)
      }
    end

    context 'with defaults with old namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => false }"
      end

      let(:title) { 'default' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'dist-datastore.cfg.xml',
        :nodes      => [ 'test.example.com', ]
      } }
      it {
        should contain_file('/etc/repose/dist-datastore.cfg.xml').
          with_content(/openrepose.org/)
      }
    end

    context 'with defaults with new namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => true }"
      end

      let(:title) { 'default' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'dist-datastore.cfg.xml',
        :nodes      => [ 'test.example.com', ]
      } }
      it {
        should contain_file('/etc/repose/dist-datastore.cfg.xml').
          with_content(/docs.openrepose.org/)
      }
    end
  end
end
