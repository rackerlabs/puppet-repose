require 'spec_helper'
describe 'repose::filter::dist_datastore', type: :define do
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
          is_expected.to raise_error(Puppet::Error, %r{nodes is a required parameter})
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
          is_expected.to contain_file('/etc/repose/dist-datastore.cfg.xml').with_ensure(
            'absent',
          )
        }
      end

      context 'providing a validator' do
        let(:title) { 'validator' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'dist-datastore.cfg.xml',
            nodes: ['test.example.com'],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/dist-datastore.cfg.xml')
            .with(
              'ensure' => 'file',
              'owner'  => 'repose',
              'group'  => 'repose',
              'mode'   => '0660',
            )
            .with_content(%r{<allow host=\"test\.example\.com\" \/>})
        }
      end

      context 'providing a connection pool ID' do
        let(:title) { 'validator' }
        let(:params) do
          {
            connection_pool_id: 'connection-pool',
            ensure: 'present',
            filename: 'dist-datastore.cfg.xml',
            nodes: ['test.example.com'],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/dist-datastore.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660',
          )
                                                                           .with_content(%r{connection-pool-id=\"connection-pool\"})
        }
      end
    end
  end
end
