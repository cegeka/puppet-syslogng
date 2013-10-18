define syslogng::config::source (
                                  $ensure = 'present',
                                  $type   = 'file',
                                  $source = undef,
                                  $options = []
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
      if $source {
        if is_absolute_path($source) {
          $_source = "\"${source}\""
        }
        else {
          $_source = $source
        }

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
        fail("Syslogng::Config::Source['${title}']: required parameter source not specified")
      }
    }
    default: {
      fail("Syslogng::Config::Source['${title}']: parameter ensure must be present or absent")
    }
  }
}
