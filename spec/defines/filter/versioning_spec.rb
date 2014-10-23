require 'spec_helper'
describe 'repose::filter::versioning', :type => :define do
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
        }.to raise_error(Puppet::Error, /target_uri is a required/)
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
      } }
      it {
        should contain_file('/etc/repose/versioning.cfg.xml').with_ensure(
          'absent')
      }
    end

    context 'providing target_uri' do
      let(:title) { 'target_uri' }
      let(:params) { { 
        :ensure     => 'present',
        :filename   => 'versioning.cfg.xml',
        :target_uri => 'http://localhost/repose',
      } }
      it { 
        should contain_file('/etc/repose/versioning.cfg.xml').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose',
          'mode'   => '0660').
          with_content(/href=\"http:\/\/localhost\/repose\"/)
      }
    end

    context 'providing target_uri and version_mappings' do
      let(:title) { 'target_uri' }
      let(:params) { { 
        :ensure           => 'present',
        :filename         => 'versioning.cfg.xml',
        :target_uri       => 'http://localhost/repose',
        :version_mappings => [
        {
          'id'     => 'v1',
          'status' => 'CURRENT',
          'media_types' => [
            { 'base' => 'application/xml', 'type' => 'application/v1+xml' },
            { 'base' => 'application/json', 'type' => 'application/v1+json' },
          ]
        } ] ,
      } }
      it { 
        should contain_file('/etc/repose/versioning.cfg.xml').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose',
          'mode'   => '0660').
          with_content(/href=\"http:\/\/localhost\/repose\"/).
          with_content(/version-mapping id=\"v1\" pp-dest-id=\"repose\" status=\"CURRENT\"/).
          with_content(/media-type base=\"application\/xml\" type=\"application\/v1\+xml\"/).
          with_content(/media-type base=\"application\/json\" type=\"application\/v1\+json\"/)
      }
    end

  end
end
