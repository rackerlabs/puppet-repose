require 'spec_helper'
describe 'repose::filter::uri_stripper', type: :define do
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
          is_expected.to contain_file('/etc/repose/uri-stripper.cfg.xml').with_content(
            %r{rewrite-location="false"},
          ).with_content(
            %r{token-index="0"},
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
          is_expected.to contain_file('/etc/repose/uri-stripper.cfg.xml').with_ensure(
            'absent',
          )
        }
      end

      context 'rewrite location true' do
        let(:title) { 'validator' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'uri-stripper.cfg.xml',
            rewrite_location: true,
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/uri-stripper.cfg.xml').with_content(%r{rewrite-location="true"})
        }
      end

      context 'rewrite location false' do
        let(:title) { 'validator' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'uri-stripper.cfg.xml',
            rewrite_location: false,
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/uri-stripper.cfg.xml').with_content(%r{rewrite-location="false"})
        }
      end

      context 'rewrite location false' do
        let(:title) { 'validator' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'uri-stripper.cfg.xml',
            token_index: 3,
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/uri-stripper.cfg.xml').with_content(%r{token-index="3"})
        }
      end
    end
  end
end
