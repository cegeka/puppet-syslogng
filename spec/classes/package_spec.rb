#!/usr/bin/env rspec

require 'spec_helper'

describe 'syslogng::package' do
  let(:facts) { {
    :osfamily        => 'RedHat'
  } }

  context 'with faulty input' do
    context 'with version => running' do
      let (:params) { { :version => 'running' } }

      it { expect { subject }.to raise_error(
        Puppet::Error, /parameter version must be present or latest/
      ) }
    end
  end

  context 'with version => present' do
    let (:params) { { :version => 'present' } }

    it { should include_class('syslogng::params') }

    it { should contain_package('syslog-ng').with_ensure('present') }
    it { should contain_package('syslog-ng-libdbi').with_ensure('present') }
  end
end
