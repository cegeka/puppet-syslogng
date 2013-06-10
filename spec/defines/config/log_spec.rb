#!/usr/bin/env rspec

require 'spec_helper'

describe 'syslogng::config::log' do
  context 'with title httpd_access_log' do
    let (:title) { 'httpd_access_log' }

    context 'on osfamily RedHat' do
      let (:facts) { {
        :osfamily => 'RedHat'
      } }

      context 'with faulty input' do
        context 'with ensure => installed' do
          let (:params) { { :ensure => 'installed' } }

          it { expect { subject }.to raise_error(
            Puppet::Error, /parameter ensure must be present or absent/
          )}
        end

        context 'without required parameters' do
          context 'without parameters' do
            let (:params) { { } }

            it { expect { subject }.to raise_error(
              Puppet::Error, /required parameters source or destination not specified/
            )}
          end
          context 'with source => localhost' do
            let (:params) { { :source => 'localhost' } }

            it { expect { subject }.to raise_error(
              Puppet::Error, /required parameters source or destination not specified/
            )}
          end
          context 'with destination => httpd_access_log' do
            let (:params) { { :destination => 'httpd_access_log' } }

            it { expect { subject }.to raise_error(
              Puppet::Error, /required parameters source or destination not specified/
            )}
          end
        end
      end

      context 'with ensure => absent' do
        let (:params) { { :ensure => 'absent' } }

        it { should include_class('syslogng::params') }

        it { should contain_file('log_httpd_access_log').with(
          :ensure => 'absent',
          :path   => '/etc/syslog-ng/includes/log/httpd_access_log.inc'
        )}
      end

      context 'with ensure => present' do
        let (:pre_condition) { [
          "syslogng::config::source { network: source => 'tcp' }",
          "syslogng::config::destination { httpd_access_log: destination => '/var/log/httpd_access_log' }",
        ] }

        context 'with required parameters' do
          let (:params) { {
            :source      => 'network',
            :destination => 'httpd_access_log',
          } }

          it { should contain_syslogng__config__log('httpd_access_log').with(
            :ensure      => 'present',
            :source      => 'network',
            :destination => 'httpd_access_log'
          )}

          it { should include_class('syslogng::params') }

          it { should contain_syslogng__config__source('network').with(
            :before => 'Syslogng::Config::Log[httpd_access_log]'
          )}

          it { should contain_syslogng__config__destination('httpd_access_log').with(
            :before => 'Syslogng::Config::Log[httpd_access_log]'
          )}

          it { should contain_file('log_httpd_access_log').with(
            :ensure  => 'file',
            :owner   => 'root',
            :group   => 'root',
            :mode    => '0644',
            :notify  => 'Class[Syslogng::Service]',
            :path    => '/etc/syslog-ng/includes/log/httpd_access_log.inc',
            :content => /^log \{ source\(network\); destination\(httpd_access_log\); \};$/
          )}
        end

        context 'with source => network, destination => httpd_access_log and flags => catchall' do
          let (:params) { {
            :source      => 'network',
            :destination => 'httpd_access_log',
            :flags       => 'catchall'
          } }

          it { should contain_file('log_httpd_access_log').with(
            :ensure  => 'file',
            :owner   => 'root',
            :group   => 'root',
            :mode    => '0644',
            :notify  => 'Class[Syslogng::Service]',
            :path    => '/etc/syslog-ng/includes/log/httpd_access_log.inc',
            :content => /^log \{ source\(network\); destination\(httpd_access_log\); flags\(catchall\); \};$/
          )}
        end

        context 'with source => network, destination => httpd_access_log and flags => [catchall, final]' do
          let (:params) { {
            :source      => 'network',
            :destination => 'httpd_access_log',
            :flags       => ['catchall', 'final']
          } }

          it { should contain_file('log_httpd_access_log').with(
            :ensure  => 'file',
            :owner   => 'root',
            :group   => 'root',
            :mode    => '0644',
            :notify  => 'Class[Syslogng::Service]',
            :path    => '/etc/syslog-ng/includes/log/httpd_access_log.inc',
            :content => /^log \{ source\(network\); destination\(httpd_access_log\); flags\(catchall, final\); \};$/
          )}
        end

        context 'with source => network, destination => httpd_access_log and filter => level' do
          let (:params) { {
            :source      => 'network',
            :destination => 'httpd_access_log',
            :filter      => 'level'
          } }

          let (:pre_condition) { [
            "syslogng::config::source { network: source => 'tcp' }",
            'syslogng::config::filter { level: expression => \'$LEVEL_NUM > 5\' }',
            "syslogng::config::destination { httpd_access_log: destination => '/var/log/httpd_access_log' }",
          ] }

          it { should include_class('syslogng::params') }

          it { should contain_syslogng__config__source('network').with(
            :before => 'Syslogng::Config::Log[httpd_access_log]'
          )}

          it { should contain_syslogng__config__filter('level').with(
            :before => 'Syslogng::Config::Log[httpd_access_log]'
          )}

          it { should contain_syslogng__config__destination('httpd_access_log').with(
            :before => 'Syslogng::Config::Log[httpd_access_log]'
          )}

          it { should contain_file('log_httpd_access_log').with(
            :ensure  => 'file',
            :owner   => 'root',
            :group   => 'root',
            :mode    => '0644',
            :notify  => 'Class[Syslogng::Service]',
            :path    => '/etc/syslog-ng/includes/log/httpd_access_log.inc',
            :content => /^log \{ source\(network\); filter\(level\); destination\(httpd_access_log\); \};$/
          )}
        end
      end
    end
  end
end
