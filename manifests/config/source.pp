define syslogng::config::source (
                                  $ensure = 'present',
                                  $configuration = undef
                                )
{
  case $ensure {
    'absent': {
      include syslogng::params

      file { "source_${title}":
        ensure => $ensure,
        path   => "${syslogng::params::conf_dir}/includes/source/${title}.inc"
      }
    }
    'present': {
      if $configuration {
        include syslogng::params

        file { "source_${title}":
          ensure  => 'file',
          owner   => $syslogng::params::user,
          group   => $syslogng::params::group,
          mode    => '0644',
          path    => "${syslogng::params::conf_dir}/includes/source/${title}.inc",
          notify  => Class['syslogng::service'],
          content => template('syslogng/config/source.erb')
        }
      }
      else {
        fail("Syslogng::Config::Source['${title}']: required parameter configuration not specified")
      }
    }
    default: {
      fail("Syslogng::Config::Source['${title}']: parameter ensure must be present or absent")
    }
  }
}
