define syslogng::loghost($ensure=present,$loghost=undef) {

  file { "${syslogng::params::syslogngcfg}/includes/loghost-${name}.inc":
    ensure  => $ensure,
    content => "@define ${name} \"${loghost}\"",
  }

}
