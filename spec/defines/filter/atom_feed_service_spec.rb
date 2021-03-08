require 'spec_helper'
describe 'repose::filter::atom_feed_service', type: :class do
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

        it { is_expected.to contain_concat('/etc/repose/atom-feed-service.cfg.xml').with_ensure('present') }
        it { is_expected.to contain_concat__fragment('header').with_target('/etc/repose/atom-feed-service.cfg.xml').with_order('01') }
        it { is_expected.to contain_concat__fragment('footer').with_target('/etc/repose/atom-feed-service.cfg.xml').with_order('99') }
      end

      context 'with ensure absent' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'absent',
          }
        end

        it {
          is_expected.to contain_concat('/etc/repose/atom-feed-service.cfg.xml').with_ensure('absent')
        }
      end
    end
  end
end
