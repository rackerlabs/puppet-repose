require 'spec_helper'
describe 'repose::filter::CHANGEME', type: :define do
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
          is_expected.to raise_error(Puppet::Error, %r{is a required})
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
          is_expected.to contain_file('/etc/repose/CHANGEME.cfg.xml').with_ensure(
            'absent',
          )
        }
      end
      context 'providing a validator' do
        let(:title) { 'validator' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'CHANGEME.cfg.xml',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/CHANGEME.cfg.xml')
        }
      end
    end
  end
end
