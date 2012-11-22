#!/usr/bin/env rspec

require 'spec_helper'

describe 'syslogng' do
  it { should contain_class 'syslogng' }
end
