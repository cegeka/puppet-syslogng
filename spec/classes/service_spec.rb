#!/usr/bin/env rspec

require 'spec_helper'

describe 'syslogng::service' do
  let (:facts) { {
    :osfamily        => 'RedHat'
  } }

  context 'with faulty input' do
    context 'with ensure => installed and enable => true' do
      let (:params) { { :ensure => 'installed', :enable => true } }

      it { expect { subject }.to raise_error(
        Puppet::Error, /parameter ensure must be running or stopped/
      )}
    end

    context 'with ensure => running and enable => foo' do
      let (:params) { { :ensure => 'running', :enable => 'foo' } }

      it { expect { subject }.to raise_error(
        Puppet::Error, /parameter enable must be a boolean/
      )}
    end
  end

  context 'with ensure => running and enable => true' do
    let (:params) { { :ensure => 'running', :enable => true } }

    it { should contain_class 'syslogng::params' }

    it { should contain_service('syslog-ng').with_ensure('running') }
    it { should contain_service('syslog-ng').with_name('syslog-ng') }
    it { should contain_service('syslog-ng').with_hasstatus(true) }
    it { should contain_service('syslog-ng').with_enable(true) }
  end

  context 'with ensure => stopped and enable => false' do
    let (:params) { { :ensure => 'stopped', :enable => false } }

    it { should contain_class 'syslogng::params' }

    it { should contain_service('syslog-ng').with_ensure('stopped') }
    it { should contain_service('syslog-ng').with_name('syslog-ng') }
    it { should contain_service('syslog-ng').with_hasstatus(true) }
    it { should contain_service('syslog-ng').with_enable(false) }
  end
end
