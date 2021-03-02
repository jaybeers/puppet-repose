require 'spec_helper'
describe 'repose::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end
      it { is_expected.to compile.with_all_deps }
      context 'with defaults for all parameters' do
        it { should contain_file('/etc/sysconfig/repose') }
          # TODO: add additional details here
        it { should contain_augeas('repose_sysconfig').with_context( 
            '/files/etc/sysconfig/repose') }
        it { should contain_augeas('repose_sysconfig').with_changes([ 
            [
            "set DAEMON_HOME '/usr/share/lib/repose'",
            "set LOG_PATH '/var/log/repose'",
            "set USER 'repose'",
            "set daemonize '/usr/sbin/daemonize'",
            "set daemonize_opts '\"-c $DAEMON_HOME -p $PID_FILE -u $USER -o $LOG_PATH/stdout.log -e $LOG_PATH/stderr.log -l /var/lock/subsys/$NAME\"'",
            "set java_opts '\"${java_opts} \"'",
            "set JAVA_OPTS '\"${JAVA_OPTS} \"'"
            ],
            "rm SAXON_HOME"
          ]) }
      end

      context 'with ensure absent' do
        let(:params) { {
          :ensure => 'absent'
        } }
        it { should contain_file('/etc/sysconfig/repose').with_ensure('absent') }
        it { should_not contain_augeas('repose_sysconfig') }
      end
    end
  end
end
