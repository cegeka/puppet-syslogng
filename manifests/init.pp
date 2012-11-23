# Class: syslogng
#
# This module manages syslogng
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class syslogng($ensure=present,$loghost=undef,$logdir=undef) {

  case $::operatingsystem {
      redhat, centos: { include syslogng::instance::redhat }
      default: { fail("${::operatingsystem} is not yet supported") }
  }

}
