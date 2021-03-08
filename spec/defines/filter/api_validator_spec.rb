require 'spec_helper'
describe 'repose::filter::api_validator', type: :define do
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
          is_expected.to raise_error(Puppet::Error, %r{validators is a required list})
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
          is_expected.to contain_file('/etc/repose/validator.cfg.xml').with_ensure(
            'absent',
          )
        }
      end

      context 'providing a validator' do
        let(:title) { 'validator' }
        let(:params) do
          {
            ensure: 'present',
            filename: 'test-validator.cfg.xml',
            validators: [{
              'role' => 'app',
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
              'join_xpath_checks'            => true,
              'enable_rax_roles'             => true,
              'mask_rax_roles_403'           => true,
            }],
            multi_role_match: true,
            delegating: true,
            delegating_quality: '0.7',
          }
        end

        it { is_expected.to contain_file('/etc/repose/test-validator.cfg.xml') }
        it {
          is_expected.to contain_file('/etc/repose/test-validator.cfg.xml')
            .with_content(%r{multi-role-match="true"})
            .with_content(%r{role="app"})
            .with_content(%r{default="true"})
            .with_content(/wadl="usage-schema\/app\.wadl"/)
            .with_content(%r{check-well-formed="true"})
            .with_content(%r{remove-dups="true"})
            .with_content(%r{check-xsd-grammar="true"})
            .with_content(%r{xpath-version="2"})
            .with_content(%r{check-plain-params="true"})
            .with_content(%r{do-xsd-grammar-transform="true"})
            .with_content(%r{xsl-engine="XalanC"})
            .with_content(%r{xsd-engine="SaxonEE"})
            .with_content(/dot-output="\/var\/repose\/validator\.dot"/)
            .with_content(%r{join-xpath-checks="true"})
            .with_content(%r{enable-rax-roles="true"})
            .with_content(%r{mask-rax-roles-403="true"})
            .with_content(%r{delegating quality="0.7"})
        }
      end
    end
  end
end
