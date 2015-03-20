require 'spec_helper'
describe 'repose::filter::compression', :type => :define do
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
        should contain_file('/etc/repose/compression.cfg.xml').with_ensure(
          'absent')
      }
    end

    context 'default parameters' do
      let(:title) { 'default' }
      it {
        should contain_file('/etc/repose/compression.cfg.xml').
          with_content(/compression compression-threshold=\"1024\" debug=\"false\" include-content-types=\"text\/html\"/)
      }
    end

    context 'with defaults with old namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => false }"
      end

      let(:title) { 'default' }
      it {
        should contain_file('/etc/repose/compression.cfg.xml').
          with_content(/docs.rackspacecloud.com/)
      }
    end

    context 'with defaults with new namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => true }"
      end

      let(:title) { 'default' }
      it {
        should contain_file('/etc/repose/compression.cfg.xml').
          with_content(/docs.openrepose.org/)
      }
    end

  end
end
