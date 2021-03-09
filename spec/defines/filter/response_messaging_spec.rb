require 'spec_helper'
describe 'repose::filter::response_messaging', type: :define do
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
          is_expected.to raise_error(Puppet::Error, %r{status_codes is a required})
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
          is_expected.to contain_file('/etc/repose/response-messaging.cfg.xml').with_ensure(
            'absent',
          )
        }
      end

      context 'providing status_codes' do
        let(:title) { 'status_codes' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'response-messaging.cfg.xml',
            status_codes: [
              {
                'id'         => '413',
                'code-regex' => '413',
                'messages'   => [
                  {
                    'media-type' => '*/*',
                    'body' => '{ "overLimit" : { "code" : 413, "message" : "OverLimit Retry...", "details" : "whatever": } }',
                  },
                ],
              },
            ],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/response-messaging.cfg.xml')
            .with(
              'ensure' => 'file',
              'owner'  => 'repose',
              'group'  => 'repose',
              'mode'   => '0660',
            )
            .with_content(%r{status-code id=\"413\" code-regex=\"413\"})
            .with_content(%r{message media-type=\"\*\/\*\"})
            .with_content(%r{\{ \"overLimit\" : \{ \"code\" : 413, \"message\" : \"OverLimit Retry\.\.\.\", \"details\" : \"whatever\": \} \}})
        }
      end
    end
  end
end
