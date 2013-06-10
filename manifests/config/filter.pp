define syslogng::config::filter (
  $ensure     = 'present',
  $expression = undef
)
{
  case $ensure {
    'absent': {
      include syslogng::params

      file { "filter_${title}":
        ensure => $ensure,
        path   => "${syslogng::params::conf_dir}/includes/filter/${title}.inc"
      }
    }
    'present': {
      if $expression {
        include syslogng::params

        file { "filter_${title}":
          ensure  => 'file',
          owner   => $syslogng::params::user,
          group   => $syslogng::params::group,
          mode    => '0644',
          path    => "${syslogng::params::conf_dir}/includes/filter/${title}.inc",
          notify  => Class['syslogng::service'],
          content => template('syslogng/config/filter.erb')
        }
      }
      else {
        fail("Syslogng::Config::Filter['${title}']: required parameter expression not specified")
      }
    }
    default: {
      fail("Syslogng::Config::Filter['${title}']: parameter ensure must be present or absent")
    }
  }
}
