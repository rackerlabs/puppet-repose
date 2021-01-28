require 'spec_helper'
describe 'repose::filter::scripting', :type => :define do
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
          should raise_error(Puppet::Error,/expects a value for parameter 'script_lang'/)
          should raise_error(Puppet::Error,/expects a value for parameter 'mod_script'/)
        }
      end

      context 'default parameters did not provide mod_script' do
        let(:title) { 'default' }
        let(:params) { {
          :script_lang => 'groovy'
        } }
        it {
          should raise_error(Puppet::Error,/expects a value for parameter 'mod_script'/)
        }
      end

      context 'with ensure absent' do
        let(:title) { 'default' }
        let(:params) { {
          :ensure => 'absent',
          :mod_script => 'script.groovy',
          :script_lang => 'groovy',
        } }
        it {
          should contain_file('/etc/repose/scripting.cfg.xml').with_ensure(
            'absent')
        }
      end
    end
  end
end