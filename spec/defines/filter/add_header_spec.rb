require 'spec_helper'
describe 'repose::filter::add_header', :type => :define do
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
      it {
        should contain_file('/etc/repose/add-header.cfg.xml').
          with_ensure('file')
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
      } }
      it {
        should contain_file('/etc/repose/add-header.cfg.xml').
          with_ensure('absent')
      }
    end

    context 'with request headers' do
      let(:title) { 'default' }
      let(:params) { {
        :request_headers => [
          {
            'name'      => 'repose-test',
            'overwrite' => 'false',
            'quality'   => '0.4',
            'value'     => 'this-is-a-test'
          }
        ]
      } }
      it {
        should contain_file('/etc/repose/add-header.cfg.xml').
          with_ensure('file').
          with_content(/ name="repose-test"/).
          with_content(/ overwrite="false"/).
          with_content(/ quality="0.4"/).
          with_content(/>this-is-a-test<\/header>/)
      }
    end
    context 'with response headers' do
      let(:title) { 'default' }
      let(:params) { {
        :response_headers => [
          {
            'name'      => 'repose-test',
            'overwrite' => 'false',
            'quality'   => '0.4',
            'value'     => 'this-is-a-test'
          }
        ]
      } }
      it {
        should contain_file('/etc/repose/add-header.cfg.xml').
          with_ensure('file').
          with_content(/ name="repose-test"/).
          with_content(/ overwrite="false"/).
          with_content(/ quality="0.4"/).
          with_content(/>this-is-a-test<\/header>/)
      }
    end

  end
end
