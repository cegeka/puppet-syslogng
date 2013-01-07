require 'spec_helper'

describe 'syslogng::params' do
  context 'on osfamily RedHat' do
    let (:facts) { {
      :osfamily => 'RedHat'
    } }

    it { should contain_class('syslogng::params') }
  end

  context 'on osfamily Debian' do
    let (:facts) { {
      :osfamily => 'Debian'
    } }

    it {expect { subject }.to raise_error( Puppet::Error, /not supported/) }
  end
end
