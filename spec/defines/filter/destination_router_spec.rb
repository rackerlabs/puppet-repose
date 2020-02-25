require 'spec_helper'
describe 'repose::filter::destination_router', :type => :define do
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
        should raise_error(Puppet::Error, /targets is a required parameter/)
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
      } }
      it {
        should contain_file('/etc/repose/destination-router.cfg.xml').with_ensure(
          'absent')
      }
    end

    context 'with targets' do
      let(:title) { 'validator' }
      let(:params) { {
        :targets => [
          { 'id' => 'target01', 'quality' => 0 },
          { 'id' => 'target02', 'quality' => 0.5 },
          { 'id' => 'target03', 'quality' => 1 },
        ]
      } }
      it {
        should contain_file('/etc/repose/destination-router.cfg.xml').
          with_content(/<destination-router xmlns='http:\/\/docs.openrepose.org\/repose\/destination-router\/v1.0'>/).
          with_content(/<target id=\"target01\" quality="0"\/>/).
          with_content(/<target id=\"target02\" quality="0.5"\/>/).
          with_content(/<target id=\"target03\" quality="1"\/>/).
          with_content(/<\/destination-router>/)
      }
    end
  end
end
