require 'spec_helper'
describe 'repose::filter::uri_stripper', :type => :define do
  let :pre_condition do
    'include repose'
  end
  context 'on RedHat' do
    let :facts do
    {
      :osfamily               => 'RedHat',
      :operationsystemrelease => '6',
    }
    end

    context 'default parameters' do
      let(:title) { 'default' }
      it {
        should contain_file('/etc/repose/uri-stripper.cfg.xml').with_content(
          /rewrite-location="false"/).with_content(
          /token-index="0"/)
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
      } }
      it {
        should contain_file('/etc/repose/uri-stripper.cfg.xml').with_ensure(
          'absent')
      }
    end

    context 'rewrite location true' do
      let(:title) { 'validator' }
      let(:params) { {
        :ensure              => 'present',
        :filename            => 'uri-stripper.cfg.xml',
        :rewrite_location    => 'true'
      } }
      it {
        should contain_file('/etc/repose/uri-stripper.cfg.xml').with_content(/rewrite-location="true"/)
      }
    end

    context 'rewrite location false' do
      let(:title) { 'validator' }
      let(:params) { {
        :ensure              => 'present',
        :filename            => 'uri-stripper.cfg.xml',
        :rewrite_location    => 'false'
      } }
      it {
        should contain_file('/etc/repose/uri-stripper.cfg.xml').with_content(/rewrite-location="false"/)
      }
    end

    context 'rewrite location false' do
      let(:title) { 'validator' }
      let(:params) { {
        :ensure              => 'present',
        :filename            => 'uri-stripper.cfg.xml',
        :token_index         => '3'
      } }
      it {
        should contain_file('/etc/repose/uri-stripper.cfg.xml').with_content(/token-index="3"/)
      }
    end
  end
end
