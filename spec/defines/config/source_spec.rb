require 'spec_helper'

describe 'syslogng::config::source' do
  let(:title) { 'logsource' }

  it { should contain_syslogng__config__source('logsource') }
end
