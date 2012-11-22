define syslogng::logdestination($ensure=present,$destinationtype=undef,$options=undef) {

  file { "${syslogng::params::syslogngcfg}/includes/${destinationtype}/${name}.inc":
    ensure  => $ensure,
    content => template('syslogng/includes/include.erb'),
  }

}
