#!/usr/bin/env rspec

require 'spec_helper'

describe 'syslogng' do
  let (:facts) {{ :operatingsystem => 'redhat' }}
  let (:params) {{ :ensure => 'present', :loghost => 'dummyhost', :logdir => '/var/log' }}
  it { should contain_class 'syslogng' }
end
