define syslogng::config::template (
  $ensure     = 'present',
  $expression = undef,
  $escape     = false
) {
  case $ensure {
    'absent': {
      include syslogng::params

      file { "template_${title}":
        ensure => $ensure,
        path   => "${syslogng::params::conf_dir}/includes/template/${title}.inc"
      }
    }
    'present': {
      if $expression {
        case $escape {
          true:    { $template_escape = 'yes' }
          false:   { $template_escape = 'no' }
          default: {
            fail("Syslogng::Config::Template['${title}']: parameter escape must be boolean")
          }
        }

        include syslogng::params

        file { "template_${title}":
          ensure  => 'file',
          owner   => $syslogng::params::user,
          group   => $syslogng::params::group,
          mode    => '0644',
          path    => "${syslogng::params::conf_dir}/includes/template/${title}.inc",
          notify  => Class['syslogng::service'],
          content => template('syslogng/config/template.erb')
        }
      }
      else {
        fail("Syslogng::Config::Template['${title}']: required parameter expression not specified")
      }
    }
    default: {
      fail("Syslogng::Config::Template['${title}']: parameter ensure must be present or absent")
    }
  }
}
