require 'spec_helper'
describe 'repose::filter::atom_feed_service', :type => :class do
  let :pre_condition do
    'include repose'
  end

  context 'on RedHat' do
    let :facts do
      {
          :osfamily               => 'RedHat',
          :operationsystemrelease => '7',
      }
    end

    context 'default parameters' do
      let(:title) { 'default' }
      it { should contain_concat('/etc/repose/atom-feed-service.cfg.xml').with_ensure('present') }
      it { should contain_concat__fragment('header').with_target('/etc/repose/atom-feed-service.cfg.xml').with_order('01') }
      it { should contain_concat__fragment('footer').with_target('/etc/repose/atom-feed-service.cfg.xml').with_order('99') }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
          :ensure => 'absent'
      } }
      it {
        should contain_concat('/etc/repose/atom-feed-service.cfg.xml').with_ensure('absent')
      }
    end

  end
end
