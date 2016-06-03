class { 'syslogng':
  enable => true,
}

syslogng::config::define { 'loghost':
  value => 'dummy.log-destination.tld',
}

syslogng::config::source { 'pipe_sunappserver_server':
  configuration => 'pipe("/var/run/sunappserver_server.pipe" flags(no-parse));'
}

syslogng::config::template { 'sunappserver_server':
  # lint:ignore:single_quote_string_with_variables
  expression => 'sunappserver_server ${MSG}\n',
  # lint:endignore
}

syslogng::config::destination { 'd_amqp_syslog':
  configuration => 'amqp(vhost("/") host("127.0.0.1") exchange("syslog"));'
}

syslogng::config::log { 'sunappserver_server':
  source      => 'pipe_sunappserver_server',
  destination => 'tcp_sunappserver_server',
}
