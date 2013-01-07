class syslogng::package (
                          $version = undef
                        )
{
  include syslogng::params

  case $version {
    'present', 'absent': { $version_real = $version }
    default:             { fail('Class[syslogng::package]: parameter version must be present or latest') }
  }

  package { $syslogng::params::package :
    ensure => $version_real
  }
}
