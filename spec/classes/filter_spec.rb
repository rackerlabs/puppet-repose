require 'spec_helper'
describe 'repose::filter' do

  context 'with defaults for all parameters' do
    it {
      expect {
        should compile
      }.to raise_error(Puppet::Error, /This class should not be used directly/)
    }
  end
end
