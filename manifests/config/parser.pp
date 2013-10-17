define syslogng::config::parser (
  $ensure     = 'present',
  $expression = undef
)
{
  case $ensure {
    'absent': {
      include syslogng::params

      file { "parser_${title}":
        ensure => $ensure,
        path   => "${syslogng::params::conf_dir}/includes/parser/${title}.inc"
      }
    }
    'present': {
      if $expression {
        include syslogng::params

        file { "parser_${title}":
          ensure  => 'file',
          owner   => $syslogng::params::user,
          group   => $syslogng::params::group,
          mode    => '0644',
          path    => "${syslogng::params::conf_dir}/includes/parser/${title}.inc",
          notify  => Class['syslogng::service'],
          content => template('syslogng/config/parser.erb')
        }
      }
      else {
        fail("Syslogng::Config::Parser['${title}']: required parameter expression not specified")
      }
    }
    default: {
      fail("Syslogng::Config::Parser['${title}']: parameter ensure must be present or absent")
    }
  }
}
