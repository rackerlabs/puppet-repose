require 'spec_helper'
describe 'repose::filter::header_translation', type: :define do
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
          is_expected.to contain_file('/etc/repose/header-translation.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660',
          )
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
          is_expected.to contain_file('/etc/repose/header-translation.cfg.xml').with_ensure(
            'absent',
          )
        }
      end

      context 'providing a translations map' do
        let(:title) { 'header_translations' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'header-translation.cfg.xml',
            header_translations: [{
              'original_name' => 'orig',
              'new_name'        => 'new',
              'remove_original' => 'true',
            }],
          }
        end

        it {
          # rubocop:disable LineLength
          # <?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\n<header-translation xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n xsi:schemaLocation=\"http://docs.api.rackspacecloud.com/repose/header-translation/v1.0 ../config/header-translation.xsd\"\n xmlns=\"http://docs.api.rackspacecloud.com/repose/header-translation/v1.0\">\n\n    <header original-name=\"orig\" new-name=\"new\" remove-original=\"true\" />\n\n</header_translation>\n
          # rubocop:enable LineLength
          is_expected.to contain_file('/etc/repose/header-translation.cfg.xml').with_content(
            %r{<header original-name=\"orig\" new-name=\"new\" remove-original=\"true\" \/>},
          )
        }
      end
    end
  end
end
