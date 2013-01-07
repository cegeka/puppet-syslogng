#!/usr/bin/env rspec

require 'spec_helper'

describe 'syslogng::config' do
  let (:facts) { {
    :osfamily => 'RedHat'
  } }

  it { should include_class('syslogng::params') }
  it { should contain_file('syslog-ng/config').with_ensure('file') }
  it { should contain_file('syslog-ng/config').with_owner('root') }
  it { should contain_file('syslog-ng/config').with_group('root') }
  it { should contain_file('syslog-ng/config').with_mode('0644') }
  it { should contain_file('syslog-ng/config').with_path('/etc/syslog-ng/syslog-ng.conf') }

  it { should contain_file('syslog-ng/includes').with_ensure('directory') }
  it { should contain_file('syslog-ng/includes').with_owner('root') }
  it { should contain_file('syslog-ng/includes').with_group('root') }
  it { should contain_file('syslog-ng/includes').with_mode('0755') }
  it { should contain_file('syslog-ng/includes').with_path('/etc/syslog-ng/includes') }

  it { should contain_file('syslog-ng/serviceconf').with_ensure('file') }
  it { should contain_file('syslog-ng/serviceconf').with_owner('root') }
  it { should contain_file('syslog-ng/serviceconf').with_group('root') }
  it { should contain_file('syslog-ng/serviceconf').with_mode('0644') }
  it { should contain_file('syslog-ng/serviceconf').with_path('/etc/sysconfig/syslog-ng') }

  it { should contain_file('syslog-ng/source').with_ensure('directory') }
  it { should contain_file('syslog-ng/source').with_owner('root') }
  it { should contain_file('syslog-ng/source').with_group('root') }
  it { should contain_file('syslog-ng/source').with_mode('0755') }
  it { should contain_file('syslog-ng/source').with_path('/etc/syslog-ng/includes/source') }

  it { should contain_file('syslog-ng/destination').with_ensure('directory') }
  it { should contain_file('syslog-ng/destination').with_owner('root') }
  it { should contain_file('syslog-ng/destination').with_group('root') }
  it { should contain_file('syslog-ng/destination').with_mode('0755') }
  it { should contain_file('syslog-ng/destination').with_path('/etc/syslog-ng/includes/destination') }

  it { should contain_file('syslog-ng/filter').with_ensure('directory') }
  it { should contain_file('syslog-ng/filter').with_owner('root') }
  it { should contain_file('syslog-ng/filter').with_group('root') }
  it { should contain_file('syslog-ng/filter').with_mode('0755') }
  it { should contain_file('syslog-ng/filter').with_path('/etc/syslog-ng/includes/filter') }

  it { should contain_file('syslog-ng/parser').with_ensure('directory') }
  it { should contain_file('syslog-ng/parser').with_owner('root') }
  it { should contain_file('syslog-ng/parser').with_group('root') }
  it { should contain_file('syslog-ng/parser').with_mode('0755') }
  it { should contain_file('syslog-ng/parser').with_path('/etc/syslog-ng/includes/parser') }

  it { should contain_file('syslog-ng/log').with_ensure('directory') }
  it { should contain_file('syslog-ng/log').with_owner('root') }
  it { should contain_file('syslog-ng/log').with_group('root') }
  it { should contain_file('syslog-ng/log').with_mode('0755') }
  it { should contain_file('syslog-ng/log').with_path('/etc/syslog-ng/includes/log') }

  context 'with logdir => /var/log' do
    let (:params) { { :logdir => '/var/log' } }

    it { should_not contain_file('syslog-ng/config').with_content(/^@define loghost/) }
    it { should contain_file('syslog-ng/config').with_content(/^@define logdir "\/var\/log"/) }
  end

  context 'with loghost => foo.example.com and logdir => /data/logs' do
    let (:params) { { :loghost => 'foo.example.com', :logdir => '/data/logs' } }

    it { should contain_file('syslog-ng/config').with_content(/^@define loghost "foo.example.com"/) }
    it { should contain_file('syslog-ng/config').with_content(/^@define logdir "\/data\/logs"/) }
  end

end
