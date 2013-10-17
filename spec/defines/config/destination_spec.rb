#!/usr/bin/env rspec

require 'spec_helper'

describe 'syslogng::config::destination' do
  context 'with title httpd_access_log' do
    let(:title) { 'httpd_access_log' }

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
            Puppet::Error, /required parameter destination not specified/
          )}
        end
      end

      context 'with ensure => absent' do
        let (:params) { { :ensure => 'absent' } }

        it { should include_class('syslogng::params') }

        it { should contain_file('destination_httpd_access_log').with(
          :ensure => 'absent',
          :path   => '/etc/syslog-ng/includes/destination/httpd_access_log.inc'
        )}
      end

      context 'with default parameters' do
        let (:params) { { :destination => '/var/log/httpd_access.log' } }

        it { should include_class('syslogng::params') }

        it { should contain_syslogng__config__destination('httpd_access_log').with(
          :logtype     => 'file',
          :destination => '/var/log/httpd_access.log',
          :ensure      => 'present',
          :options     => []
        )}

        it { should contain_file('destination_httpd_access_log').with(
          :ensure  => 'file',
          :owner   => 'root',
          :group   => 'root',
          :mode    => '0644',
          :notify  => 'Class[Syslogng::Service]',
          :path    => '/etc/syslog-ng/includes/destination/httpd_access_log.inc',
          :content => /^destination httpd_access_log \{ file\(\/var\/log\/httpd_access\.log\); \};$/
        )}
      end

      context 'with :destination => /bin/script, type => program and options => template("<$PRI>$DATE $MSG\n") flags(no_multi_line)' do
        let (:params) { {
          :destination => '/bin/script',
          :logtype     => 'program',
          :options     => ['template("<$PRI>$DATE $MSG\n")', 'flags(no_multi_line)']
        } }

        it { should include_class('syslogng::params') }

        it { pending('Awaiting rspec-puppet 0.2.0'); should contain_file('destination_httpd_access_log').with(
          :ensure  => 'file',
          :owner   => 'root',
          :group   => 'root',
          :mode    => '0644',
          :notify  => 'Class[Syslogng::Service]',
          :path    => '/etc/syslog-ng/includes/destination/httpd_access_log.inc',
          :content => /^destination httpd_access_log \{ program\("\/bin\/script" template\("<\$PRI>\$DATE \$MSG\\n"\) flags\(no_multi_line\)\); \};$/
        )}
      end
    end
  end
end
