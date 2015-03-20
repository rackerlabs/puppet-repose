require 'spec_helper'
describe 'repose::filter::uri_normalization', :type => :define do
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
        should contain_file('/etc/repose/uri-normalization.cfg.xml')
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
      } }
      it {
        should contain_file('/etc/repose/uri-normalization.cfg.xml').with_ensure(
          'absent')
      }
    end

    context 'with media_types' do
      let(:title) { 'headers' }
      let(:params) { {
        :media_types => [
          { 'name' => 'application/xml', 'variant-extension' => 'xml' },
          { 'name' => 'application/json', 'variant-extension' => 'json' },
        ]
      } }
      it {
        should contain_file('/etc/repose/uri-normalization.cfg.xml').
          with_content(/<media-variants>/).
          with_content(/<media-type name=\"application\/xml\" variant-extension=\"xml\" \/>/).
          with_content(/<media-type name=\"application\/json\" variant-extension=\"json\" \/>/).
          with_content(/<\/media-variants>/)
      }
    end

    context 'with uri_filters' do
      let(:title) { 'headers' }
      let(:params) { {
        :uri_filters => [
         {
            'uri-regex'    => '/.*test',
            'http-methods' => 'GET',
            'alphabetize'  => 'false',
            'whitelists'   => [
              {
                'id'         => 'something',
                'parameters' => [
                  {
                    'name'           => 'test',
                    'multiplicity'   => '0',
                    'case-sensitive' => 'false',
                  }
                ],
              }
            ],
         }
       ]
      } }
      it {
        should contain_file('/etc/repose/uri-normalization.cfg.xml').
          with_content(/uri-regex="\/\.\*test"/).
          with_content(/http-methods="GET"/).
          with_content(/alphabetize="false"/).
          with_content(/whitelist id="something"/).
          with_content(/case-sensitive="false"/).
          with_content(/multiplicity="0"/).
          with_content(/name="test"/)
      }
    end

    context 'with defaults with old namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => false }"
      end

      let(:title) { 'default' }
      it {
        should contain_file('/etc/repose/uri-normalization.cfg.xml').
          with_content(/docs.rackspacecloud.com/)
      }
    end

    context 'with defaults with new namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => true }"
      end

      let(:title) { 'default' }
      it {
        should contain_file('/etc/repose/uri-normalization.cfg.xml').
          with_content(/docs.openrepose.org/)
      }
    end
  end
end
