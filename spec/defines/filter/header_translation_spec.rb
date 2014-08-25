require 'spec_helper'
describe 'repose::filter::header_translation', :type => :define do
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
        should contain_file('/etc/repose/header-translation.cfg.xml').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose',
          'mode'   => '0660')
      }
    end

    context 'providing a translations map' do
      let(:title) { 'header_translations' }
      let(:params) { { 
        :ensure     => 'present',
        :filename   => 'header-translation.cfg.xml',
        :header_translations => [ {
          'original_name'   => 'orig',
          'new_name'        => 'new',
          'remove_original' => 'true'
        } ]
      } }
      it { 
        # <?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\n<header-translation xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n xsi:schemaLocation=\"http://docs.api.rackspacecloud.com/repose/header-translation/v1.0 ../config/header-translation.xsd\"\n xmlns=\"http://docs.api.rackspacecloud.com/repose/header-translation/v1.0\">\n\n    <header original-name=\"orig\" new-name=\"new\" remove-original=\"true\" />\n\n</header_translation>\n
        should contain_file('/etc/repose/header-translation.cfg.xml').with_content(
          /<header original-name=\"orig\" new-name=\"new\" remove-original=\"true\" \/>/
        )
      }
    end
  end
end
