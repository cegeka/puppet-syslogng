class { 'syslogng':
  enable => true,
}

syslogng::config::define { 'loghost':
  value => 'dummy.log-destionation.tld'
}

syslogng::config::define { 'logdir':
  value => '/var/log'
}

syslogng::config::destination { 'httpd_access_log':
  logtype => 'file',
  destination => '/var/log/httpd_access.log',
}

syslogng::config::destination { 'script_destination':
  logtype     => 'program',
  destination => '/bin/script',
  options     => ['template("<$PRI>$DATE $MSG\n")', 'flags(no_multi_line)'],
}


