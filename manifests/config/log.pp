define syslogng::config::log (
  $ensure      = 'present',
  $source      = undef,
  $destination = undef,
  $parser      = undef,
  $filter      = undef,
  $rewrite     = undef,
  $flags       = []
) {
  case $ensure {
    'absent': {
      include syslogng::params

      file {"log_${title}":
        ensure => $ensure,
        path   => "${syslogng::params::conf_dir}/includes/log/${title}.inc"
      }
    }
    'present': {
      if ($source and $destination) {
        include syslogng::params

        file { "log_${title}":
          ensure  => 'file',
          owner   => $syslogng::params::user,
          group   => $syslogng::params::group,
          mode    => '0644',
          path    => "${syslogng::params::conf_dir}/includes/log/${title}.inc",
          notify  => Class['syslogng::service'],
          content => template('syslogng/config/log.erb')
        }

        Syslogng::Config::Source[$source] -> Syslogng::Config::Log[$title]
        Syslogng::Config::Destination[$destination] -> Syslogng::Config::Log[$title]

        if $filter {
          Syslogng::Config::Filter[$filter] -> Syslogng::Config::Log[$title]
        }
        if $parser {
          Syslogng::Config::Parser[$parser] -> Syslogng::Config::Log[$title]
        }
      }
      else {
        fail("Syslogng::Config::Log['${title}']: required parameters source or destination not specified")
      }
    }
    default: {
      fail("Syslogng::Config::Log['${title}']: parameter ensure must be present or absent")
    }
  }
}
