#  class syslogng::params
#
class syslogng::params {

  case $facts['os']['family'] {
    'RedHat': {
      $user              = 'root'
      $group             = 'root'
      $service           = 'syslog-ng'
      $service_hasstatus = true
      $conf_dir          = '/etc/syslog-ng'
      $conf_file         = 'syslog-ng.conf'
      $sysconf_dir       = '/etc/sysconfig'
      case $facts['os']['release']['major'] {
        '7': { $config_template = 'syslog-ng.conf-el7.erb'
          $package         = ['syslog-ng', 'syslog-ng-libdbi'] }
        '8': { $config_template = 'syslog-ng.conf-el8.erb'
          $package         = ['syslog-ng', 'syslog-ng-libdbi'] }
        '9': { $config_template = 'syslog-ng.conf-el9.erb'
          $package         = 'syslog-ng'}
        default: {}
      }
    }
    default: {
      fail("Class[syslogng::params]: osfamily ${facts['os']['family']} is not supported")
    }
  }
}
