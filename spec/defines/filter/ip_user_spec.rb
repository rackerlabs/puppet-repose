require 'spec_helper'
describe 'repose::filter::ip_user', :type => :define do
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
          should raise_error(Puppet::Error,/expects a value for parameter 'filter_groups'/)
        }
      end

      context 'with ensure absent' do
        let(:title) { 'default' }
        let(:params) { {
          :ensure => 'absent',
          :filter_groups => [ {} ],
        } }
        it {
          should contain_file('/etc/repose/ip-user.cfg.xml').with_ensure(
            'absent')
        }
      end

      context 'providing a filter group' do
        let(:title) { 'whitelist' }
        let(:params) { {
          :ensure        => 'present',
          :filename      => 'ip-user.cfg.xml',
          :filter_groups => [
              { 'name' => 'group1', 'addresses' => [ '9.9.9.9/0', '0.0.0.0/0' ], }
          ],
          :group_header  => 'X-PP-Repose-Group',
          :quality       => '0.25',
          :user_header   => 'X-PP-Repose-User'
        } }
        it {
          should contain_file('/etc/repose/ip-user.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/<group name="group1">/).
            with_content(/<cidr-ip>9\.9\.9\.9\/0<\/cidr-ip>/)
        }
      end

      context 'providing a user header name' do
        let(:title) { 'whitelist' }
        let(:params) { {
          :ensure        => 'present',
          :filename      => 'ip-user.cfg.xml',
          :filter_groups => [
              { 'name' => 'group1', 'addresses' => [ '9.9.9.9/0', '0.0.0.0/0' ], }
          ],
          :group_header  => 'X-PP-Repose-Group',
          :quality       => '0.25',
          :user_header   => 'X-PP-Repose-User'
        } }
        it {
          should contain_file('/etc/repose/ip-user.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/<user-header name="X-PP-Repose-User" quality="0.25"\/>/)
        }
      end

      context 'providing a group header name' do
        let(:title) { 'whitelist' }
        let(:params) { {
          :ensure        => 'present',
          :filename      => 'ip-user.cfg.xml',
          :filter_groups => [
              { 'name' => 'group1', 'addresses' => [ '9.9.9.9/0', '0.0.0.0/0' ], }
          ],
          :group_header  => 'X-PP-Repose-Group',
          :quality       => '0.25',
          :user_header   => 'X-PP-Repose-User'
        } }
        it {
          should contain_file('/etc/repose/ip-user.cfg.xml').with(
            'ensure' => 'file',
            'owner'  => 'repose',
            'group'  => 'repose',
            'mode'   => '0660').
            with_content(/<group-header name="X-PP-Repose-Group" quality="0.25"\/>/)
        }
      end
    end
  end
end