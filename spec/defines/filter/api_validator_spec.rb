require 'spec_helper'
describe 'repose::filter::api_validator', :type => :define do
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
        expect { 
          should compile
        }.to raise_error(Puppet::Error, /validators is a required list/)
      }
    end

    context 'providing a validator' do
      let(:title) { 'validator' }
      let(:params) { { 
        :ensure     => 'present',
        :filename   => 'test-validator.cfg.xml',
        :validators => [ {
          'role'                         => 'app',
          'default'                      => true,
          'wadl'                         => 'usage-schema/app.wadl',
          'check_well_formed'            => true,
          'remove_dups'                  => true,
          'check_xsd_grammar'            => true,
          'check_elements'               => true,
          'xpath_version'                => 2,
          'check_plain_params'           => true,
          'do_xsd_grammar_transform'     => true,
          'enable_pre_process_extension' => true,
          'xsl_engine'                   => 'XalanC',
          'xsd_engine'                   => 'SaxonEE',
          'dot_output'                   => '/var/repose/validator.dot',
          'join_xpath_checks'           => true,
        }, ],
        :multi_role_match => true,
      } }
      it { 
        should contain_file('/etc/repose/test-validator.cfg.xml')
        should contain_file('/etc/repose/test-validator.cfg.xml').
          with_content(/multi-role-match="true"/).
          with_content(/role="app"/).
          with_content(/default="true"/).
          with_content(/wadl="usage-schema\/app\.wadl"/).
          with_content(/check-well-formed="true"/).
          with_content(/remove-dups="true"/).
          with_content(/check-xsd-grammar="true"/).
          with_content(/xpath-version="2"/).
          with_content(/check-plain-params="true"/).
          with_content(/do-xsd-grammar-transform="true"/).
          with_content(/xsl-engine="XalanC"/).
          with_content(/xsd-engine="SaxonEE"/).
          with_content(/dot-output="\/var\/repose\/validator\.dot"/).
          with_content(/join-xpath-checks="true"/)
      }
    end
  end
end
