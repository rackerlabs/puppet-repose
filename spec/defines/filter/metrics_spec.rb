require 'spec_helper'
describe 'repose::filter::metrics', :type => :define do
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
          should raise_error(Puppet::Error, /expects a value for parameter 'graphite_servers'/)
        }
      end

      context 'with ensure absent' do
        let(:title) { 'default' }
        let(:params) { {
          :ensure => 'absent',
          :graphite_servers => [ {} ],
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
    end
  end
end