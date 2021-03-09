require 'spec_helper'
describe 'repose::filter::add_header', type: :define do
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
          is_expected.to contain_file('/etc/repose/add-header.cfg.xml')
            .with_ensure('file')
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
          is_expected.to contain_file('/etc/repose/add-header.cfg.xml')
            .with_ensure('absent')
        }
      end

      context 'with request headers' do
        let(:title) { 'default' }
        let(:params) do
          {
            request_headers: [
              {
                'name'      => 'repose-test',
                'overwrite' => 'false',
                'quality'   => '0.4',
                'value'     => 'this-is-a-test',
              },
            ],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/add-header.cfg.xml')
            .with_ensure('file')
            .with_content(%r{ name="repose-test"})
            .with_content(%r{ overwrite="false"})
            .with_content(%r{ quality="0.4"})
            .with_content(%r{>this-is-a-test<\/header>})
        }
      end
      context 'with response headers' do
        let(:title) { 'default' }
        let(:params) do
          {
            response_headers: [
              {
                'name'      => 'repose-test',
                'overwrite' => 'false',
                'quality'   => '0.4',
                'value'     => 'this-is-a-test',
              },
            ],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/add-header.cfg.xml')
            .with_ensure('file')
            .with_content(%r{ name="repose-test"})
            .with_content(%r{ overwrite="false"})
            .with_content(%r{ quality="0.4"})
            .with_content(%r{>this-is-a-test<\/header>})
        }
      end
    end
  end
end
