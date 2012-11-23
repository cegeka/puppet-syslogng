class syslogng::instance::redhat {

  include syslogng::params

  package { ['syslog-ng','syslog-ng-libdbi']:
    ensure => $syslogng::params::real_ensure,
  }

  service { 'syslog-ng':
    ensure    => $syslogng::params::real_ensure_service,
    hasstatus => true,
    enable    => true,
    require   => [
      File['/etc/sysconfig/syslog-ng'],
      File['/etc/syslog-ng/syslog-ng.conf'],
      File['/etc/syslog-ng/includes'],
      File["${syslogng::params::syslogngcfg}/includes/log"],
      File["${syslogng::params::syslogngcfg}/includes/source"],
      File["${syslogng::params::syslogngcfg}/includes/filter"],
      File["${syslogng::params::syslogngcfg}/includes/parser"],
      File["${syslogng::params::syslogngcfg}/includes/destination"],
    ],
  }

  file { '/etc/init.d/syslog-ng':
    ensure  => file,
    source  => 'puppet:///modules/syslogng/syslog-ng.init',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['syslog-ng'],
  }

  file { '/etc/sysconfig/syslog-ng':
    ensure  => file,
    source  => 'puppet:///modules/syslogng/syslog-ng.sysconfig',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['syslog-ng'],
  }

  file { '/etc/syslog-ng/syslog-ng.conf':
    ensure  => file,
    content => template('syslogng/syslog-ng.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['syslog-ng'],
    notify  => Service['syslog-ng'],
  }

  file { '/etc/syslog-ng/includes':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['syslog-ng'],
  }

  file { [
    "${syslogng::params::syslogngcfg}/includes/log",
    "${syslogng::params::syslogngcfg}/includes/source",
    "${syslogng::params::syslogngcfg}/includes/filter",
    "${syslogng::params::syslogngcfg}/includes/parser",
    "${syslogng::params::syslogngcfg}/includes/destination"]:
    ensure => directory
  }

}
