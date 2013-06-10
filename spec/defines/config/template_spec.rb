#!/usr/bin/env rspec

require 'spec_helper'

describe 'syslogng::config::template' do
  context 'with title filetemplate' do
    let (:title) { 'filetemplate' }

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

        it { should contain_file('template_filetemplate').with(
          :ensure => 'absent',
          :path   => '/etc/syslog-ng/includes/template/filetemplate.inc'
        )}
      end

      context 'with required parameters' do
        let (:params) { { :expression => 'text_prefix' } }

        it { should contain_syslogng__config__template('filetemplate').with(
          :ensure     => 'present',
          :expression => 'text_prefix',
          :escape     => false
        )}

        it { should contain_file('template_filetemplate').with(
          :ensure  => 'file',
          :owner   => 'root',
          :group   => 'root',
          :mode    => '0644',
          :notify  => 'Class[Syslogng::Service]',
          :path    => '/etc/syslog-ng/includes/template/filetemplate.inc',
          :content => /^template filetemplate \{ template\("text_prefix"\); template_escape\(no\); \};$/
        )}
      end

      context 'with expression => text_prefix and escape => foo' do
        let (:params) { {
          :expression => 'text_prefix',
          :escape     => 'foo'
        } }

        it { expect { subject }.to raise_error(
          Puppet::Error, /parameter escape must be boolean/
        )}
      end

      context 'with expression => text_prefix and escape => true' do
        let (:params) { {
          :expression => 'text_prefix',
          :escape     => true
        } }

        it { should include_class('syslogng::params') }

        it { should contain_file('template_filetemplate').with(
          :ensure  => 'file',
          :owner   => 'root',
          :group   => 'root',
          :mode    => '0644',
          :notify  => 'Class[Syslogng::Service]',
          :path    => '/etc/syslog-ng/includes/template/filetemplate.inc',
          :content => /^template filetemplate \{ template\("text_prefix"\); template_escape\(yes\); \};$/
        )}
      end

      context 'with expression => $ISODATE $HOST $MSG\n and escape => true' do
        let (:params) { {
          :expression => '$ISODATE $HOST $MSG\n',
          :escape     => true
        } }

        it { should include_class('syslogng::params') }

        it { pending('Awaiting rspec-puppet 0.2.0'); should contain_file('template_filetemplate').with(
          :ensure  => 'file',
          :owner   => 'root',
          :group   => 'root',
          :mode    => '0644',
          :notify  => 'Class[Syslogng::Service]',
          :path    => '/etc/syslog-ng/includes/template/filetemplate.inc',
          :content => /^template filetemplate \{ template\("\$ISODATE \$HOST \$MSG\\n"\); template_escape\(yes\); \};$/
        )}
      end
    end
  end
end
