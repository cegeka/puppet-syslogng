#!/usr/bin/env rspec

require 'spec_helper'

describe 'syslogng::config::define' do
  context 'with title foo' do
    let (:title) { 'foo' }

    context 'on osfamily RedHat' do
      let (:facts) { {
        :osfamily => 'RedHat'
      } }

      it { should include_class('syslogng::params') }

      it { should contain_file('syslogng/define/foo.inc').with(
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644',
        :path   => '/etc/syslog-ng/includes/define/foo.inc'
      )}

      context 'with default parameters' do
        let (:params) { { } }

        it { should contain_syslogng__config__define('foo').with_value('') }
        it { should contain_file('syslogng/define/foo.inc').with_content(/@define foo ""/) }
      end

      context 'with value => test' do
        let (:params) { { :value => 'test' } }

        it { should contain_file('syslogng/define/foo.inc').with_content(/@define foo "test"/) }
      end
    end
  end
end
