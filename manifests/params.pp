class syslogng::params {

  $real_ensure = $syslogng::ensure
  $real_ensure_service = $syslogng::ensure ? {
    absent  => 'stopped',
    default => 'running',
  }

  $syslogngcfg = '/etc/syslog-ng'
  $real_loghost = $syslogng::loghost

}
