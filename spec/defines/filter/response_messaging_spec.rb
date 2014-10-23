require 'spec_helper'
describe 'repose::filter::response_messaging', :type => :define do
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
        expect { 
          should compile
        }.to raise_error(Puppet::Error, /status_codes is a required/)
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
      } }
      it {
        should contain_file('/etc/repose/response-messaging.cfg.xml').with_ensure(
          'absent')
      }
    end

    context 'providing status_codes' do
      let(:title) { 'status_codes' }
      let(:params) { { 
        :ensure     => 'present',
        :filename   => 'response-messaging.cfg.xml',
        :status_codes  => [
        {
          'id'         => '413',
          'code-regex' => '413',
          'messages'   => [
            {
              'media-type' => '*/*',
              'body' => '{ "overLimit" : { "code" : 413, "message" : "OverLimit Retry...", "details" : "whatever": } }',
            }
          ]
        } ]
      } }
      it { 
        should contain_file('/etc/repose/response-messaging.cfg.xml').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose',
          'mode'   => '0660').
          with_content(/status-code id=\"413\" code-regex=\"413\"/).
          with_content(/message media-type=\"\*\/\*\"/).
          with_content(/\{ \"overLimit\" : \{ \"code\" : 413, \"message\" : \"OverLimit Retry\.\.\.\", \"details\" : \"whatever\": \} \}/)
      }
    end
  end
end
