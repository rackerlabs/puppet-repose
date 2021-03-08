require 'spec_helper'
describe 'repose::filter::scripting', type: :define do
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
          is_expected.to raise_error(Puppet::Error, %r{script_lang is a required parameter})
        }
      end

      context 'default parameters did not provide mod_script' do
        let(:title) { 'default' }
        let(:params) do
          {
            script_lang: 'groovy',
          }
        end

        it {
          is_expected.to raise_error(Puppet::Error, %r{mod_script is a required parameter})
        }
      end

      context 'with ensure absent' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'absent',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/scripting.cfg.xml').with_ensure(
            'absent',
          )
        }
      end
    end
  end
end
