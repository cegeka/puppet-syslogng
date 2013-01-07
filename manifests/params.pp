class syslogng::params {

  case $::osfamily {
    'RedHat': {
      $user              = 'root'
      $group             = 'root'
      $package           = ['syslog-ng', 'syslog-ng-libdbi']
      $service           = 'syslog-ng'
      $service_hasstatus = true
      $conf_dir          = '/etc/syslog-ng'
      $conf_file         = 'syslog-ng.conf'
      $sysconf_dir       = '/etc/sysconfig'
    }
    default: {
      fail("Class[syslogng::params]: osfamily ${::osfamily} is not supported")
    }
  }
}
