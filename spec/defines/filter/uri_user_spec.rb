require 'spec_helper'
describe 'repose::filter::uri_user', :type => :define do
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
          should raise_error(Puppet::Error,/mappings is a required parameter/)
        }
      end

      context 'with ensure absent' do
        let(:title) { 'default' }
        let(:params) { {
          :ensure => 'absent'
        } }
        it {
          should contain_file('/etc/repose/uri-user.cfg.xml').with_ensure(
            'absent')
        }
      end

      context 'providing a mapping' do
        let(:title) { 'mapping' }
        let(:params) { {
          :ensure        => 'present',
          :filename      => 'uri-user.cfg.xml',
          :mappings      => [
            { "id" => "main", "regex" => ".*" }
          ],
          :group         => 'User_Standard',
          :quality       => '0.8'
        } }
        it {
          should contain_file('/etc/repose/uri-user.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/<mapping id="main" identification-regex=".*"\/>/)
        }
      end

      context 'providing a group value' do
        let(:title) { 'group value' }
        let(:params) { {
          :ensure        => 'present',
          :filename      => 'uri-user.cfg.xml',
          :mappings      => [
            { "id" => "main", "regex" => ".*" }
          ],
          :group         => 'User_Standard',
          :quality       => '0.8'
        } }
        it {
          should contain_file('/etc/repose/uri-user.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/<group>User_Standard<\/group>/)
        }
      end

      context 'providing a quality value' do
        let(:title) { 'quality value' }
        let(:params) { {
          :ensure        => 'present',
          :filename      => 'uri-user.cfg.xml',
          :mappings      => [
            { "id" => "main", "regex" => ".*" }
          ],
          :group         => 'User_Standard',
          :quality       => '0.8'
        } }
        it {
          should contain_file('/etc/repose/uri-user.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/<quality>0.8<\/quality>/)
        }
      end
    end
  end
end