class { 'syslogng':
  ensure  => present,
}

syslogng::loghost { 'loghost':
  loghost => 'dummy.log-destionation.tld'
}

syslogng::logdir { 'logdir':
  logdir => '/var/log'
}

syslogng::logdestination { 's_pipe_sunappserver_server':
  ensure          => present,
  destinationtype => 'source',
  options         => [
    'pipe("/var/run/sunappserver_server.pipe"',
    'flags(no-parse));',
  ]
}
syslogng::logpermission { '/var/run/sunappserver_server.pipe':
  group => 'tomcat',
  mode  => '0664',
}

syslogng::logdestination { 'sunappserver_server':
  ensure          => present,
  destinationtype => 'template',
  options         => [
    "template(\"sunappserver_server ${MSG}\n\");",
  ]
}

syslogng::logdestination { 'log_sunappserver_server':
  ensure          => present,
  destinationtype => 'destination',
  options         => [
    "file(\"`logdir`/sunappserver/server_${YEAR}-${MONTH}-${DAY}.log\");",
  ]
}

syslogng::logdestination { 'log':
  ensure          => present,
  destinationtype => 'log',
  options         => [
    'source(s_pipe_sunappserver_server);',
    'destination(log_sunappserver_server);',
  ]
}
