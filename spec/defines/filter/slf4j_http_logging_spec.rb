require 'spec_helper'
describe 'repose::filter::slf4j_http_logging', :type => :define do
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
        }.to raise_error(Puppet::Error, /log_files is a required/)
      }
    end

    context 'providing log_files' do
      let(:title) { 'log_files' }
      let(:params) { { 
        :ensure     => 'present',
        :filename   => 'slf4j-http-logging.cfg.xml',
        :log_files  => [ { 
          'id'       => 'my-log', 
          'format'   => 'my format',
        } ]
      } }
      it { 
        should contain_file('/etc/repose/slf4j-http-logging.cfg.xml').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose',
          'mode'   => '0660').
          with_content(/id=\"my-log\"/).
          with_content(/format=\"my format\"/)
      }
    end
  end
end
