class syslogng::params {

  $real_ensure = $syslogng::ensure
  $real_ensure_service = $syslogng::ensure ? {
    absent  => 'stopped',
    default => 'running',
  }

  if $syslogng::logdir {
    $real_logdir = $syslogng::logdir
  } else {
    $real_logdir = '/var/log'
  }

  $syslogngcfg = '/etc/syslog-ng'
  $real_loghost = $syslogng::loghost

}
