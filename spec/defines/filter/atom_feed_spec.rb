require 'spec_helper'
describe 'repose::filter::atom_feed', :type => :define do
  let :pre_condition do
    'include repose'
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end

      context 'default parameters' do
        let(:title) { 'some_feed' }
        it {
          should raise_error(Puppet::Error, /expects a value for parameter 'feed_uri'/)
        }
      end

      context 'bad ordering' do
        let(:title) { 'some_feed' }
        let(:params) { {
            :feed_uri    => 'http://foo.bar',
            :entry_order => 'banana'
        } }
        it {
          should raise_error(Puppet::Error, /expects a match for Enum\['read', 'reverse-read'\], got 'banana'/)
        }
      end

      context 'incomplete auth' do
        let(:title) { 'some_feed' }
        let(:params) { {
            :feed_uri      => 'http://foo.bar',
            :auth_username => 'banana'
        } }
        it {
          should raise_error(Puppet::Error, /If one of auth_uri, auth_username, or auth_password are used, all are required/)
        }
      end

      context 'with ensure absent' do
        let(:title) { 'some_feed' }
        let(:params) { {
            :feed_uri           => 'http://foo.bar',
            :connection_pool_id => 'pool_id',
            :entry_order        => 'reverse-read',
            :auth_uri           => 'http://bar.foo',
            :auth_username      => 'gandalf',
            :auth_password      => 'youshallnotpass',
            :auth_timeout       => '42',
            :configdir          => '/etc/repose',

        } }
        it {
          should contain_concat__fragment('feed-some_feed').
              with_target('/etc/repose/atom-feed-service.cfg.xml').
              with_order('50')
        }
      end
    end
  end
end