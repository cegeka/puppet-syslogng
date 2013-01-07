class syslogng::service (
                          $ensure = undef,
                          $enable = undef
                        )
{
  case $ensure {
    'running', 'stopped': { $ensure_real = $ensure }
    default:              { fail('Class[syslogng::service]: parameter ensure must be running or stopped') }
  }

  case $enable {
    true, false: { $enable_real = $enable }
    default:     { fail('Class[syslogng::service]: parameter enable must be a boolean') }
  }

  include syslogng::params

  service { 'syslog-ng':
    ensure    => $ensure_real,
    name      => $syslogng::params::service,
    enable    => $enable_real,
    hasstatus => $syslogng::params::service_hasstatus
  }
}
