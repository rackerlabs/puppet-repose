require 'spec_helper'
describe 'repose::filter::metrics', :type => :define do
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
        }.to raise_error(Puppet::Error, /graphite_servers is a required/)
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
      } }
      it {
        should contain_file('/etc/repose/metrics.cfg.xml').with_ensure(
          'absent')
      }
    end

    context 'providing a graphite server' do
      let(:title) { 'graphite_server' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'metrics.cfg.xml',
        :graphite_servers => [ {
          'host'    => 'graphite.server',
          'port'    => '2013',
          'period'  => 10,
          'prefix'  => 'my/prefix',
          'enabled' => 'true'
        } ]
      } }
      it {
        should contain_file('/etc/repose/metrics.cfg.xml').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose',
          'mode'   => '0660').
          with_content(/host=\"graphite\.server\"/).
          with_content(/port=\"2013\"/).
          with_content(/period=\"10\"/).
          with_content(/prefix=\"my\/prefix\"/)
      }
    end

    context 'with defaults with old namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => false }"
      end

      let(:title) { 'default' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'metrics.cfg.xml',
        :graphite_servers => [ {
          'host'    => 'graphite.server',
          'port'    => '2013',
          'period'  => 10,
          'prefix'  => 'my/prefix',
          'enabled' => 'true'
        } ]
      } }
      it {
        should contain_file('/etc/repose/metrics.cfg.xml').
          with_content(/docs.rackspacecloud.com/)
      }
    end

    context 'with defaults with new namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => true }"
      end

      let(:title) { 'default' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'metrics.cfg.xml',
        :graphite_servers => [ {
          'host'    => 'graphite.server',
          'port'    => '2013',
          'period'  => 10,
          'prefix'  => 'my/prefix',
          'enabled' => 'true'
        } ]
      } }
      it {
        should contain_file('/etc/repose/metrics.cfg.xml').
          with_content(/docs.openrepose.org/)
      }
    end
  end
end
