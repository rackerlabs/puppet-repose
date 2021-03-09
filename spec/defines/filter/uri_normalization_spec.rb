require 'spec_helper'
describe 'repose::filter::uri_normalization', type: :define do
  let :pre_condition do
    'include repose'
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end

      context 'default parameters' do
        let(:title) { 'default' }

        it {
          is_expected.to contain_file('/etc/repose/uri-normalization.cfg.xml')
        }
      end

      context 'with ensure absent' do
        let(:title) { 'default' }
        let(:params) do
          {
            ensure: 'absent',
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/uri-normalization.cfg.xml').with_ensure(
            'absent',
          )
        }
      end

      context 'with media_types' do
        let(:title) { 'headers' }
        let(:params) do
          {
            media_types: [
              { 'name' => 'application/xml', 'variant-extension' => 'xml' },
              { 'name' => 'application/json', 'variant-extension' => 'json' },
            ],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/uri-normalization.cfg.xml')
            .with_content(%r{<media-variants>})
            .with_content(%r{<media-type name=\"application\/xml\" variant-extension=\"xml\" \/>})
            .with_content(%r{<media-type name=\"application\/json\" variant-extension=\"json\" \/>})
            .with_content(%r{<\/media-variants>})
        }
      end

      context 'with uri_filters' do
        let(:title) { 'headers' }
        let(:params) do
          {
            uri_filters: [
              {
                'uri-regex' => '/.*test',
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
                      },
                    ],
                  },
                ],
              },
            ],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/uri-normalization.cfg.xml')
            .with_content(%r{uri-regex="\/\.\*test"})
            .with_content(%r{http-methods="GET"})
            .with_content(%r{alphabetize="false"})
            .with_content(%r{whitelist id="something"})
            .with_content(%r{case-sensitive="false"})
            .with_content(%r{multiplicity="0"})
            .with_content(%r{name="test"})
        }
      end
    end
  end
end
