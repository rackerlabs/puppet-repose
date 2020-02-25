require 'spec_helper'
describe 'repose::filter::http_logging', :type => :define do
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
        should raise_error(Puppet::Error, /log_files is a required parameter/)
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
      } }
      it {
        should contain_file('/etc/repose/http-logging.cfg.xml').with_ensure(
          'absent')
      }
    end

    context 'providing a log_file' do
      let(:title) { 'log_file' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'http-logging.cfg.xml',
        :log_files  => [ {
          'id'       => 'my-log',
          'format'   => 'my format',
          'location' => '/var/log/repose/http.log'
        } ]
      } }
      it {
        should contain_file('/etc/repose/http-logging.cfg.xml').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose',
          'mode'   => '0660').
          with_content(/<http-log id="my-log" format="my format">/).
          with_content(/<file location=\"\/var\/log\/repose\/http.log\"\/>/)
      }
    end
  end
end
