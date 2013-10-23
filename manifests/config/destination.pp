define syslogng::config::destination (
                                  $ensure        = 'present',
                                  $configuration = undef
                                )
{
  case $ensure {
    'absent': {
      include syslogng::params

      file { "destination_${title}":
        ensure => $ensure,
        path   => "${syslogng::params::conf_dir}/includes/destination/${title}.inc"
      }
    }
    'present': {
      if $configuration {
        include syslogng::params

        file { "destination_${title}":
          ensure  => 'file',
          owner   => $syslogng::params::user,
          group   => $syslogng::params::group,
          mode    => '0644',
          path    => "${syslogng::params::conf_dir}/includes/destination/${title}.inc",
          notify  => Class['syslogng::service'],
          content => template('syslogng/config/destination.erb')
        }

      }
      else {
        fail("Syslogng::Config::Destination['${title}']: required parameter configuration not specified")
      }
    }
    default: {
      fail("Syslogng::Config::Destination['${title}']: parameter ensure must be present or absent")
    }
  }
}
