define syslogng::config::define (
                                  $value = ''
                                )
{
  include syslogng::params

  file { "syslogng/define/${title}.inc":
    ensure  => 'file',
    owner   => $syslogng::params::user,
    group   => $syslogng::params::group,
    mode    => '0644',
    path    => "${syslogng::params::conf_dir}/includes/define/${title}.inc",
    content => "@define ${title} \"${value}\"\n"
  }
}
