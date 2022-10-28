require 'spec_helper'
describe 'repose::filter' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end
      let(:pre_condition) do
        # Fake assert_private function from stdlib to not fail within this test
        'function assert_private () { }'
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('repose::filter::container') }
    end
  end
end
