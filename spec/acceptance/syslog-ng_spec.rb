require 'spec_helper_acceptance'

describe 'syslogng' do

  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
        include yum
        include stdlib
        include stdlib::stages
        include profile::package_management

        class { 'cegekarepos' : stage => 'setup_repo' }

        Yum::Repo <| title == 'epel' |>

        class { 'syslogng':
          enable => true,
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe service('syslog-ng') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
