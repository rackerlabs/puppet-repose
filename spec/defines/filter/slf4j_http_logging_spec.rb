require 'spec_helper'
describe 'repose::filter::slf4j_http_logging', type: :define do
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
          is_expected.to raise_error(Puppet::Error, %r{log_files is a required})
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
          is_expected.to contain_file('/etc/repose/slf4j-http-logging.cfg.xml').with_ensure(
            'absent',
          )
        }
      end

      context 'providing log_files' do
        let(:title) { 'log_files' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'slf4j-http-logging.cfg.xml',
            log_files: [{
              'id' => 'my-log',
              'format' => 'my format',
            }],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/slf4j-http-logging.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660',
          )
                                                                               .with_content(%r{id=\"my-log\"})
                                                                               .with_content(%r{format=\"my format\"})
        }
      end
    end
  end
end
