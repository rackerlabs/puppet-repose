require 'spec_helper'
describe 'repose::filter::header_user', :type => :define do
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
        should contain_file('/etc/repose/header-user.cfg.xml').with(
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
        should contain_file('/etc/repose/header-user.cfg.xml').with_ensure(
                   'absent')
      }
    end

        context 'providing merge header definitions' do
          let(:title) { 'merge_header' }
          let(:params) { {
                :ensure     => 'present',
                :filename   => 'header-user.cfg.xml',
                :source_headers => [
                        { 'header_name1' => '.95' },
                        { 'header_name2' => '.05' }
                     ],
          } }
          it {
              should contain_file('/etc/repose/header-user.cfg.xml').with_content(
                    /<header id="header_name1" value=".95"\/>/
              )
            }
        end
  end
end
