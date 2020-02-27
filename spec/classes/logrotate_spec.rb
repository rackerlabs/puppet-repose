require 'spec_helper'
describe 'repose::logrotate' do
  context 'on RedHat' do
    let :facts do
    {
      :osfamily               => 'RedHat',
      :operationsystemrelease => '7',
    }
    end
    it { is_expected.to compile.with_all_deps }
    # the defaults for the logrotate class should
    # 1) specify a logrotate file
    # 2) set the frequency to daily
    # 3) keep 4 files
    # 4) compress, delaycompress, dateext are enabled
    context 'with defaults for all parameters' do
      it {
        should contain_file('/etc/logrotate.d/repose').with(
          'ensure' => 'file',
          'owner'  => 'root',
          'group'  => 'root').
          with_content(/\/var\/log\/repose\/repose\.log/).
          with_content(/rotate 4/).
          with_content(/missingok/).
          with_content(/compress/).
          with_content(/delaycompress/).
          with_content(/copytruncate/).
          with_content(/dateext/)
      }
    end

    context 'configure params parameters' do
      let(:params) { {
        :log_files        => [ '/repose1.log', '/repose2.log' ],
        :rotate_frequency => 'weekly',
        :rotate_count     => 10,
        :compress         => false,
        :delay_compress   => false,
        :use_date_ext     => false
      } }
      it {
        should contain_file('/etc/logrotate.d/repose').with(
          'ensure' => 'file',
          'owner'  => 'root',
          'group'  => 'root').
          with_content(/\/repose1\.log/).
          with_content(/\/repose2\.log/).
          with_content(/rotate 10/).
          with_content(/missingok/).
          with_content(/copytruncate/)
      }
    end
  end
end
