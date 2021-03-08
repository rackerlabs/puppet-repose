require 'spec_helper'
describe 'repose::filter::header_user', type: :define do
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
          is_expected.to contain_file('/etc/repose/header-user.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660',
          )
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
          is_expected.to contain_file('/etc/repose/header-user.cfg.xml').with_ensure(
            'absent',
          )
        }
      end

      context 'providing header user definitions' do
        let(:title) { 'header_user' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'header-user.cfg.xml',
            source_headers: [
              { 'name' => 'header_name1', 'value' => '.95' },
              { 'name' => 'header_name2', 'value' => '.05' },
            ],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/header-user.cfg.xml').with_content(
            /<header id="header_name1" quality=".95" \/>/,
          )
        }
      end
    end
  end
end
