class syslogng::config ($options = []) {

  include syslogng::params

  File {
    owner => $syslogng::params::user,
    group => $syslogng::params::group,
  }

  file { 'syslog-ng/config' :
    ensure  => file,
    path    => "${syslogng::params::conf_dir}/${syslogng::params::conf_file}",
    mode    => '0644',
    content => template("syslogng/${syslogng::params::config_template}")
  }

  file { 'syslog-ng/serviceconf' :
    ensure => file,
    path   => "${syslogng::params::sysconf_dir}/${syslogng::params::service}",
    mode   => '0644'
  }

  file { 'syslog-ng/includes' :
    ensure => directory,
    path   => "${syslogng::params::conf_dir}/includes",
    mode   => '0755'
  }

  file { 'syslog-ng/define' :
    ensure => directory,
    path   => "${syslogng::params::conf_dir}/includes/define",
    mode   => '0755'
  }

  file { 'syslog-ng/source' :
    ensure => directory,
    path   => "${syslogng::params::conf_dir}/includes/source",
    mode   => '0755'
  }

  file { 'syslog-ng/parser' :
    ensure => directory,
    path   => "${syslogng::params::conf_dir}/includes/parser",
    mode   => '0755'
  }

  file { 'syslog-ng/filter' :
    ensure => directory,
    path   => "${syslogng::params::conf_dir}/includes/filter",
    mode   => '0755'
  }

  file { 'syslog-ng/template' :
    ensure => directory,
    path   => "${syslogng::params::conf_dir}/includes/template",
    mode   => '0755'
  }

  file { 'syslog-ng/destination' :
    ensure => directory,
    path   => "${syslogng::params::conf_dir}/includes/destination",
    mode   => '0755'
  }

  file { 'syslog-ng/log' :
    ensure => directory,
    path   => "${syslogng::params::conf_dir}/includes/log",
    mode   => '0755'
  }

  file { 'syslog-ng/rewrite' :
    ensure => directory,
    path   => "${syslogng::params::conf_dir}/includes/rewrite",
    mode   => '0755'
  }
}
