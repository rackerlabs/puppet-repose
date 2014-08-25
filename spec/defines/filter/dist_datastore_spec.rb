require 'spec_helper'
describe 'repose::filter::dist_datastore', :type => :define do
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
        }.to raise_error(Puppet::Error, /nodes is a required parameter/)
      }
    end

    context 'providing a validator' do
      let(:title) { 'validator' }
      let(:params) { { 
        :ensure     => 'present',
        :filename   => 'dist-datastore.cfg.xml',
        :nodes      => [ 'test.example.com', ]
      } }
      it { 
        should contain_file('/etc/repose/dist-datastore.cfg.xml').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose',
          'mode'   => '0660').
          with_content(/<allow host=\"test\.example\.com\" \/>/)
      }
    end
  end
end
