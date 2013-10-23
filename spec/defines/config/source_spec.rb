#!/usr/bin/env rspec

require 'spec_helper'

describe 'syslogng::config::source' do
  context 'with title sunappserver_server_log' do
    let(:title) { 'sunappserver_server_log' }

    context 'on osfamily RedHat' do
      let (:facts) { {
        :osfamily => 'RedHat'
      } }

      context 'with faulty input' do
        context 'with ensure => running' do
          let (:params) { { :ensure => 'running' } }

          it { expect { subject }.to raise_error(
            Puppet::Error, /parameter ensure must be present or absent/
          )}
        end

        context 'without required parameters' do
          let (:params) { { } }

          it { expect { subject }.to raise_error(
            Puppet::Error, /required parameter configuration not specified/
          )}
        end
      end

      context 'with ensure => absent' do
        let (:params) { { :ensure => 'absent' } }

        it { should include_class('syslogng::params') }

        it { should contain_file('source_sunappserver_server_log').with(
          :ensure => 'absent',
          :path   => '/etc/syslog-ng/includes/source/sunappserver_server_log.inc'
        )}
      end

      context 'with default parameters' do
        let (:params) { { :configuration => 'file("/var/log/sunappserver.log");' } }

        it { should include_class('syslogng::params') }

        it { should contain_syslogng__config__source('sunappserver_server_log').with(
          :configuration => 'file("/var/log/sunappserver.log");',
          :ensure        => 'present'
        )}

        it { should contain_file('source_sunappserver_server_log').with(
          :ensure  => 'file',
          :owner   => 'root',
          :group   => 'root',
          :mode    => '0644',
          :notify  => 'Class[Syslogng::Service]',
          :path    => '/etc/syslog-ng/includes/source/sunappserver_server_log.inc',
          :content => /^source sunappserver_server_log \{ file\("\/var\/log\/sunappserver\.log"\); \};$/
        )}
      end

      context 'with configuration => pipe("/var/run/sunappserver_server.pipe" flags(no-parse) optional(yes)' do
        let (:params) { {
          :configuration => 'pipe("/var/run/sunappserver_server.pipe" flags(no-parse) optional(yes));'
        } }

        it { should include_class('syslogng::params') }

        it { should contain_file('source_sunappserver_server_log').with(
          :ensure  => 'file',
          :owner   => 'root',
          :group   => 'root',
          :mode    => '0644',
          :notify  => 'Class[Syslogng::Service]',
          :path    => '/etc/syslog-ng/includes/source/sunappserver_server_log.inc',
          :content => /^source sunappserver_server_log \{ pipe\("\/var\/run\/sunappserver_server\.pipe" flags\(no-parse\) optional\(yes\)\); \};$/
        )}
      end
    end
  end
end
