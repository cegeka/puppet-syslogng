define syslogng::logdir($ensure=present,$logdir=undef) {

  file { "${syslogng::params::syslogngcfg}/includes/logdir-${name}.inc":
    ensure  => $ensure,
    content => "@define ${name} \"${logdir}\"",
  }

}
