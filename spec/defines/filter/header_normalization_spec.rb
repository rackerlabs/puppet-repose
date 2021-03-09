require 'spec_helper'
describe 'repose::filter::header_normalization', type: :define do
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
          is_expected.to contain_file('/etc/repose/header-normalization.cfg.xml')
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
          is_expected.to contain_file('/etc/repose/header-normalization.cfg.xml').with_ensure(
            'absent',
          )
        }
      end

      context 'with header_filters' do
        let(:title) { 'headers' }
        let(:params) do
          {
            header_filters: [
              {
                'uri-regex' => '/.*test',
                'http-methods' => 'GET',
                'blacklists'   => [
                  {
                    'id' => 'rate-limit-headers',
                    'headers' => [
                      'X-PP-User',
                      'X-PP-Groups',
                    ],
                  },
                ],
                'whitelists' => [
                  {
                    'id' => 'creds',
                    'headers' => [
                      'X-Auth-Key',
                      'X-Auth-User',
                    ],
                  },
                ],
              },
            ],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/header-normalization.cfg.xml')
            .with_content(%r{uri-regex="\/\.\*test"})
            .with_content(%r{http-methods="GET"})
            .with_content(%r{blacklist id="rate-limit-headers"})
            .with_content(%r{header id="X-PP-User"})
            .with_content(%r{header id="X-PP-Groups"})
            .with_content(%r{whitelist id="creds"})
            .with_content(%r{header id="X-Auth-Key"})
            .with_content(%r{header id="X-Auth-User"})
        }
      end
    end
  end
end
