require 'spec_helper'
describe 'repose::filter::scripting', :type => :define do
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
        should raise_error(Puppet::Error,/script_lang is a required parameter/)
      }
    end

    context 'default parameters did not provide mod_script' do
      let(:title) { 'default' }
      let(:params) { {
        :script_lang => 'groovy'
      } }
      it {
        should raise_error(Puppet::Error,/mod_script is a required parameter/)
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
      } }
      it {
        should contain_file('/etc/repose/scripting.cfg.xml').with_ensure(
          'absent')
      }
    end

    context 'with required args with old namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => false }"
      end

      let(:title) { 'default' }
      let(:params) { {
        :ensure      => 'present',
        :filename    => 'scripting.cfg.xml',
        :script_lang => 'groovy',
        :mod_script  => 'modification',
      } }
      it {
        should contain_file('/etc/repose/scripting.cfg.xml').
          with_content(/docs.rackspacecloud.com/)
      }
    end

    context 'with required args with new namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => true }"
      end

      let(:title) { 'default' }
      let(:params) { {
        :ensure      => 'present',
        :filename    => 'scripting.cfg.xml',
        :script_lang => 'groovy',
        :mod_script  => 'modification',
      } }
      it {
        should contain_file('/etc/repose/scripting.cfg.xml').
          with_content(/docs.openrepose.org/)
      }
    end

    context 'providing a modification script' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure      => 'present',
        :filename    => 'scripting.cfg.xml',
        :script_lang => 'groovy',
        :mod_script  => 'modification',
      } }
      it {
        should contain_file('/etc/repose/scripting.cfg.xml').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose',
          'mode'   => '0660').
          with_content(/language="groovy">/).
          with_content(/modification/)
      }
    end
  end
end
