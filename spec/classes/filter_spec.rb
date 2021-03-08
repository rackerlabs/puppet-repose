require 'spec_helper'
describe 'repose::filter' do
  context 'with defaults for all parameters' do
    it do
      is_expected.to raise_error(Puppet::Error, %r{This class should not be used directly})
    end
  end
end
