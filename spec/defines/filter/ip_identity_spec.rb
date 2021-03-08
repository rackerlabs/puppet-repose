require 'spec_helper'
describe 'repose::filter::ip_identity', type: :define do
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
          is_expected.to raise_error(Puppet::Error, %r{whitelist is a required parameter})
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
          is_expected.to contain_file('/etc/repose/ip-identity.cfg.xml').with_ensure(
            'absent',
          )
        }
      end

      context 'providing a whitelist' do
        let(:title) { 'whitelist' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'ip-identity.cfg.xml',
            quality: '0.25',
            whitelist: {
              'quality' => '0.3',
              'addresses' => ['9.9.9.9'],
            },
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/ip-identity.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660',
          )
            .with_content(/<quality>0.25<\/quality>/)
            .with_content(%r{<white-list quality=\"0\.3\">})
                                                                        .with_content(/<ip-address>9\.9\.9\.9<\/ip-address>/)
        }
      end
    end
  end
end
