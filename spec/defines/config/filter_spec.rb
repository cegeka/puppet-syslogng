#!/usr/bin/rspec

require 'spec_helper'

describe "syslogng::config::filter" do
  context 'with title sunappserver_gc' do
    let (:title) { 'sunappserver_gc' }

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
            Puppet::Error, /required parameter expression not specified/
          )}
        end
      end

      context 'with ensure => absent' do
        let (:params) { { :ensure => 'absent' } }

        it { should include_class('syslogng::params') }

        it { should contain_file('filter_sunappserver_gc').with(
          :ensure => 'absent',
          :path   => '/etc/syslog-ng/includes/filter/sunappserver_gc.inc'
        )}
      end

      context 'with default parameters' do
        let (:params) { { :expression => 'host(example1)' } }

        it { should contain_syslogng__config__filter('sunappserver_gc').with(
          :ensure     => 'present',
          :expression => 'host(example1)'
        )}

        it { should include_class('syslogng::params') }

        it { should contain_file('filter_sunappserver_gc').with(
          :ensure  => 'file',
          :owner   => 'root',
          :group   => 'root',
          :mode    => '0644',
          :notify  => 'Class[Syslogng::Service]',
          :path    => '/etc/syslog-ng/includes/filter/sunappserver_gc.inc',
          :content => /^filter sunappserver_gc \{ host\(example1\); \};$/
        )}
      end

      context 'with expression => "$HOST$PID" eq "$HOST"' do
        let (:params) { { :expression => '"$HOST$PID" eq "$HOST"' } }

        it { should include_class('syslogng::params') }

        it { pending('Awaiting rspec-puppet 0.2.0'); should contain_file('filter_sunappserver_gc').with(
          :ensure  => 'file',
          :owner   => 'root',
          :group   => 'root',
          :mode    => '0644',
          :notify  => 'Class[Syslogng::Service]',
          :path    => '/etc/syslog-ng/includes/filter/sunappserver_gc.inc',
          :content => /^filter sunappserver_gc \{ "\$HOST\$PID" eq "\$HOST"; \};$/
        )}
      end
    end
  end

end
