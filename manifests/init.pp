# Class: syslogng
#
# This module manages syslogng
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class syslogng (
                $version       = 'present',
                $logdir        = '/var/log',
                $loghost       = undef,
                $enable        = true,
                $service_state = 'running'
              )
{
  case $version {
    'present', 'latest': { $version_real = $version }
    default:             { fail('Class[syslogng]: parameter version must be present or latest') }
  }

  case $logdir {
    /^\/.*/: { $logdir_real = $logdir }
    default: { fail('Class[syslogng]: parameter logdir must be an absolute path') }
  }

  case $enable {
    true, false: { $enable_real = $enable }
    default:     { fail('Class[syslogng]: parameter enable must be a boolean') }
  }

  case $service_state {
    'running', 'stopped': { $service_state_real = $service_state }
    default:     { fail('Class[syslogng]: parameter service_state must be running or stopped') }
  }

  case $::osfamily {
    'RedHat': {
      include syslogng::params

      class { 'syslogng::package':
        version => $version_real
      }
      class { 'syslogng::config':
        logdir  => $logdir_real,
        loghost => $loghost
      }
      class { 'syslogng::service':
        ensure => $service_state_real,
        enable => $enable_real
      }

      Class['syslogng::package'] -> Class['syslogng::config']
      Class['syslogng::config'] ~> Class['syslogng::service']
      Class['syslogng::service'] -> Class['syslogng']
    }
    default: {
      fail("Class['syslogng']: osfamily ${::osfamily} is not supported")
    }
  }
}
