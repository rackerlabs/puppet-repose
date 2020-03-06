require 'spec_helper'
describe 'repose::filter::dist_datastore', :type => :define do
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

      context 'providing a connection pool ID' do
        let(:title) { 'validator' }
        let(:params) { {
          :connection_pool_id => 'connection-pool',
          :ensure             => 'present',
          :filename           => 'dist-datastore.cfg.xml',
          :nodes              => [ 'test.example.com', ]
        } }
        it {
          should contain_file('/etc/repose/dist-datastore.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/connection-pool-id=\"connection-pool\"/)
        }
      end
    end
  end
end