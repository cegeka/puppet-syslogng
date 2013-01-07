define syslogng::logpermission (
                                $owner = 'root',
                                $group = 'root',
                                $mode  = '0644'
                              )
{
  file { $title:
    mode  => $mode,
    owner => $owner,
    group => $group,
  }
}
