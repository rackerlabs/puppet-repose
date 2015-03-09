require 'spec_helper'
describe 'repose::filter::translation', :type => :define do
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
        should contain_file('/etc/repose/translation.cfg.xml').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose',
          'mode'   => '0660')

        should contain_file('/etc/repose/translation.cfg.xml').
          with_content(/xsl-engine=\"SaxonHE\"/)
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
      } }
      it {
        should contain_file('/etc/repose/translation.cfg.xml').with_ensure(
          'absent')
      }
    end

    context 'providing parameters' do
      let(:title) { 'validator' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'translation.cfg.xml',
        :response_translations => [
          {
            'code_regex'              => '20[01]',
            'content_type'            => '*/*',
            'accept'                  => '*/*',
            'translated_content_type' => '*/*',
            'styles'                  => [
              {
                'id'       => 'wadly',
                'filename' => 'schema/wadl/mywadl.xsl'
              }
            ]
          }
        ],
        :xsl_engine => 'SaxonEE'
      } }
      it {
        should contain_file('/etc/repose/translation.cfg.xml').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose',
          'mode'   => '0660').
          with_content(/xsl-engine=\"SaxonEE\"/).
          with_content(/code-regex=\"20\[01\]\"/).
          with_content(/content-type=\"\*\/\*\"/).
          with_content(/accept=\"\*\/\*\"/).
          with_content(/translated-content-type=\"\*\/\*\"/).
          with_content(/id=\"wadly\" href=\"schema\/wadl\/mywadl\.xsl\"/)
      }
    end

    context 'with defaults with old namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => false }"
      end

      let(:title) { 'default' }
      it {
        should contain_file('/etc/repose/translation.cfg.xml').
          with_content(/docs.rackspacecloud.com/)
      }
    end

    context 'with defaults with new namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => true }"
      end

      let(:title) { 'default' }
      it {
        should contain_file('/etc/repose/translation.cfg.xml').
          with_content(/docs.openrepose.org/)
      }
    end

  end
end
