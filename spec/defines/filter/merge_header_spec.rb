require 'spec_helper'
describe 'repose::filter::merge_header', :type => :define do
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
        should contain_file('/etc/repose/merge-header.cfg.xml').with(
          'ensure' => 'file',
          'owner'  => 'repose',
          'group'  => 'repose',
          'mode'   => '0660')
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
      } }
      it {
        should contain_file('/etc/repose/merge-header.cfg.xml').with_ensure(
          'absent')
      }
    end

    context 'providing merge header definitions' do
      let(:title) { 'merge_header' }
      let(:params) { {
        :ensure     => 'present',
        :filename   => 'merge-header.cfg.xml',
        :request_headers=> [ 
            'header_name1',
            'header_name2',
            'header_name3',
         ],
        :response_headers=> [ 
            'header_name4',
            'header_name5',
            'header_name6',
         ]
      } }
      it {
# <?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<merge-header xmlns=\"http://docs.openrepose.org/repose/merge-header/v1.0\">\n\t<request>\n\t\t<header>header_name1</header>\n\t\t<header>header_name2</header>\n\t\t<header>header_name3</header>\n\t\t</request>\n\t<response>\n\t\t<header>header_name4</header>\n\t\t<header>header_name5</header>\n\t\t<header>header_name6</header>\n\t</response>\n</merge-header>
        should contain_file('/etc/repose/merge-header.cfg.xml').with_content(
          /<header>header_name1<\/header>/
        ).with_content(
          /<response>/
        ).with_content(
         /<request>/
        )
      }
    end

    context 'with defaults with new namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => true }"
      end

      let(:title) { 'default' }
      it {
        should contain_file('/etc/repose/merge-header.cfg.xml').
          with_content(/docs.openrepose.org/)
      }
    end
  end
end
