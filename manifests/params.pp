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
      case $::operatingsystemmajrelease {
        '6': { $config_template = 'syslog-ng.conf-el6.erb' }
        '7': { $config_template = 'syslog-ng.conf-el7.erb' }
        '8': { $config_template = 'syslog-ng.conf-el8.erb' }
        default: {}
      }
    }
    default: {
      fail("Class[syslogng::params]: osfamily ${::osfamily} is not supported")
    }
  }
}
