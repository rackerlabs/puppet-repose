require 'spec_helper'
describe 'repose::filter::header_normalization', :type => :define do
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
        should contain_file('/etc/repose/header-normalization.cfg.xml')
      }
    end

    context 'with ensure absent' do
      let(:title) { 'default' }
      let(:params) { {
        :ensure => 'absent'
      } }
      it {
        should contain_file('/etc/repose/header-normalization.cfg.xml').with_ensure(
          'absent')
      }
    end

    context 'with header_filters' do
      let(:title) { 'headers' }
      let(:params) { {
        :header_filters => [
         {
            'uri-regex'    => '/.*test',
            'http-methods' => 'GET',
            'blacklists'   => [
              {
                'id'    => 'rate-limit-headers',
                'headers' => [
                  'X-PP-User',
                  'X-PP-Groups'
                ]
              }
            ],
            'whitelists'   => [
              {
                'id'    => 'creds',
                'headers' => [
                  'X-Auth-Key',
                  'X-Auth-User'
                ]
              }
            ],
         }
       ]
      } }
      it {
        should contain_file('/etc/repose/header-normalization.cfg.xml').
          with_content(/uri-regex="\/\.\*test"/).
          with_content(/http-methods="GET"/).
          with_content(/blacklist id="rate-limit-headers"/).
          with_content(/header id="X-PP-User"/).
          with_content(/header id="X-PP-Groups"/).
          with_content(/whitelist id="creds"/).
          with_content(/header id="X-Auth-Key"/).
          with_content(/header id="X-Auth-User"/).
          without_content(/<request>/).
          without_content(/<\/request>/).
          without_content(/<response>/).
          without_content(/<\/response>/)
      }
    end

    context 'with direction for header_filters' do
      let(:title) { 'headers' }
      let(:params) { {
        :header_filters => [
         {
            'direction'    => 'request',
            'uri-regex'    => '/.*test',
            'http-methods' => 'GET',
            'blacklists'   => [
              {
                'id'    => 'rate-limit-headers',
                'headers' => [
                  'X-PP-User',
                  'X-PP-Groups'
                ]
              }
            ],
            'whitelists'   => [
              {
                'id'    => 'creds',
                'headers' => [
                  'X-Auth-Key',
                  'X-Auth-User'
                ]
              }
            ],
         }
       ]
      } }
      it {
        should contain_file('/etc/repose/header-normalization.cfg.xml').
          with_content(/uri-regex="\/\.\*test"/).
          with_content(/http-methods="GET"/).
          with_content(/blacklist id="rate-limit-headers"/).
          with_content(/header id="X-PP-User"/).
          with_content(/header id="X-PP-Groups"/).
          with_content(/whitelist id="creds"/).
          with_content(/header id="X-Auth-Key"/).
          with_content(/header id="X-Auth-User"/).
          with_content(/<request>/).
          with_content(/<\/request>/).
          without_content(/<response>/)
      }
    end

    context 'with direction response for header_filters' do
      let(:title) { 'headers' }
      let(:params) { {
        :header_filters => [
         {
            'direction'    => 'response',
            'uri-regex'    => '/.*test',
            'http-methods' => 'GET',
            'blacklists'   => [
              {
                'id'    => 'rate-limit-headers',
                'headers' => [
                  'X-PP-User',
                  'X-PP-Groups'
                ]
              }
            ],
            'whitelists'   => [
              {
                'id'    => 'creds',
                'headers' => [
                  'X-Auth-Key',
                  'X-Auth-User'
                ]
              }
            ],
         }
       ]
      } }
      it {
        should contain_file('/etc/repose/header-normalization.cfg.xml').
          with_content(/uri-regex="\/\.\*test"/).
          with_content(/http-methods="GET"/).
          with_content(/blacklist id="rate-limit-headers"/).
          with_content(/header id="X-PP-User"/).
          with_content(/header id="X-PP-Groups"/).
          with_content(/whitelist id="creds"/).
          with_content(/header id="X-Auth-Key"/).
          with_content(/header id="X-Auth-User"/).
          without_content(/<request>/).
          without_content(/<\/request>/).
          with_content(/<response>/).
          with_content(/<\/response>/)
      }
    end

    context 'with two targets direction response for header_filters' do
      let(:title) { 'headers' }
      let(:params) { {
        :header_filters => [
         {
            'direction'    => 'response',
            'blacklists'   => [
              {
                'id'    => 'rate-limit-headers',
                'headers' => [
                  'X-PP-User',
                  'X-PP-Groups'
                ]
              }
            ]
         },
         {
            'direction'    => 'request',
            'blacklists'   => [
              {
                'id'    => 'rate-limit-headers',
                'headers' => [
                  'X-PP-User',
                  'X-PP-Groups'
                ]
              }
            ]
         }
       ]
      } }
      it {
        should contain_file('/etc/repose/header-normalization.cfg.xml').
          without_content(/uri-regex="\/\.\*test"/).
          without_content(/http-methods="GET"/).
          with_content(/blacklist id="rate-limit-headers"/).
          with_content(/header id="X-PP-User"/).
          with_content(/header id="X-PP-Groups"/).
          without_content(/whitelist id="creds"/).
          with_content(/<request>/).
          with_content(/<\/request>/).
          with_content(/<response>/).
          with_content(/<\/response>/)
      }
    end

    context 'with defaults with old namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => false }"
      end

      let(:title) { 'default' }
      it {
        should contain_file('/etc/repose/header-normalization.cfg.xml').
          with_content(/docs.api.rackspacecloud.com/)
      }
    end

    context 'with defaults with new namespace' do
      let :pre_condition do
        "class { 'repose': cfg_new_namespace => true }"
      end

      let(:title) { 'default' }
      it {
        should contain_file('/etc/repose/header-normalization.cfg.xml').
          with_content(/docs.openrepose.org/)
      }
    end
  end
end
