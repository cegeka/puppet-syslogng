class { 'syslogng':
  enable => true,
}

syslogng::config::define { 'loghost':
  value => 'dummy.log-destination.tld',
}

syslogng::config::source { 's_pipe_sunappserver_server':
  type    => 'pipe',
  source  => '/var/run/sunappserver_server.pipe',
  options => 'flags(no-parse)',
}

syslogng::config::template { 'sunappserver_server':
  expression => 'sunappserver_server ${MSG}\n',
}

syslogng::config::destination { 'tcp_sunappserver_server':
  logtype     => 'tcp',
  destination => '`loghost`',
  options     => 'template(sunappserver_server)',
}

syslogng::config::log { 'sunappserver_server':
  source      => 's_pipe_sunappserver_server',
  destination => 'tcp_sunappserver_server',
}
