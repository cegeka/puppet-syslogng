require 'spec_helper'

describe 'syslogng::params' do
  context 'on osfamily Debian' do
    let (:facts) { {
      :osfamily => 'Debian'
    } }

    it {expect { subject }.to raise_error( Puppet::Error, /not supported/) }
  end

  context 'on osfamily RedHat' do
    let (:facts) { {
      :osfamily => 'RedHat'
    } }

    it { should contain_class('syslogng::params') }

    it { pending('Awaiting rspec-puppet 0.2.0'); should have_resource_count(0) }
    it { pending('Awaiting rspec-puppet 0.2.0'); should have_class_count(1) }
  end
end
