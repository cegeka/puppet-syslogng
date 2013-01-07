define syslogng::logdestination (
                                  $ensure  = 'present',
                                  $type    = undef,
                                  $options = undef
                                )
{
  include syslogng::params

  file { "${type}/${title}.inc":
    ensure  => $ensure
    owner   => $syslogng::params::user
    group   => $syslogng::params::group
    path    => "${syslogng::params::conf_dir}/includes/${type}/${title}.inc",
    content => template('syslogng/includes/include.erb'),
  }

}
