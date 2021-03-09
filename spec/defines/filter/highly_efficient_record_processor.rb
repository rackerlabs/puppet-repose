require 'spec_helper'
describe 'repose::filter::highly_efficient_record_processor', type: :define do
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
          is_expected.to contain_file('/etc/repose/highly-efficient-record-processor.cfg.xml')
            .with_ensure('file')
            .with_content(%r{pre-filter-logger-name="org.openrepose.herp.pre.filter"})
            .with_content(%r{post-filter-logger-name="org.openrepose.herp.post.filter"})
            .with_content(%r{service-code="repose"})
            .with_content(%r{region="USA"})
            .with_content(%r{data-center="DFW"})
            .with_content(%r{crush="false"})
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
          is_expected.to contain_file('/etc/repose/highly-efficient-record-processor.cfg.xml').with_ensure(
            'absent',
          )
        }
      end

      context 'with filter_out' do
        let(:title) { 'default' }
        let(:params) do
          {
            'filter_out' => [
              { 'match' => [
                { 'field' => 'userName', 'regex' => 'foo' },
                { 'field' => 'region', 'regex' => 'DFW' },
              ] },
              { 'match' => [
                { 'field' => 'userName', 'regex' => 'bar' },
                { 'field' => 'parameters.abc', 'regex' => '123' },
              ] },

            ],
          }
        end

        it {
          is_expected.to contain_file('/etc/repose/highly-efficient-record-processor.cfg.xml')
            .with_ensure('file')
            .with_content(%r{field="userName" regex="foo"})
            .with_content(%r{field="region" regex="DFW"})
            .with_content(%r{field="userName" regex="bar"})
            .with_content(%r{field="paramters.abc" regex="123"})
        }
      end
    end
  end
end
