#!/usr/bin/env rspec

require 'spec_helper'

describe 'syslogng' do
  context 'with faulty input' do
    context 'with version => running' do
      let (:params) { { :version => 'running' } }

      it { expect { subject }.to raise_error(
        Puppet::Error, /parameter version must be present or latest/
      )}
    end

    context 'with service_state => foo' do
      let (:params) { { :service_state => 'foo' } }

      it { expect { subject }.to raise_error(
        Puppet::Error, /parameter service_state must be running or stopped/
      )}
    end

    context 'enable => bar' do
      let (:params) { { :enable => 'bar' } }

      it { expect { subject }.to raise_error(
        Puppet::Error, /parameter enable must be a boolean/
      )}
    end

  end

  context 'on osfamily RedHat' do
    let (:facts) { {
      :osfamily => 'RedHat'
    } }

    context 'with default parameters' do
      let (:params) { { } }

      it { should include_class('syslogng::params') }

      it { should contain_class('syslogng').with_version('present') }
      it { should contain_class('syslogng').with_service_state('running') }
      it { should contain_class('syslogng').with_enable(true) }

      it { should contain_class('syslogng::package').with_version('present') }
      it { should contain_class('syslogng::service').with_ensure('running') }
      it { should contain_class('syslogng::service').with_enable(true) }

      it { should contain_class('syslogng::package').with_before('Class[Syslogng::Config]') }
      it { should contain_class('syslogng::config').with_notify('Class[Syslogng::Service]') }

      # Light weight version of the anchor pattern
      it { should contain_class('syslogng::service').with_before('Class[Syslogng]') }
    end
  end

  context 'on osfamily Debian' do
    let (:facts) { {
      :osfamily => 'Debian'
    } }

    it {expect { subject }.to raise_error( Puppet::Error, /not supported/) }
  end
end
