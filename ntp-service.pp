# Define a class for NTP installation and configuration
class ntp_install {

  # Define package name based on the operating system
  $ntp_package = $::osfamily ? {
    'RedHat' => 'ntp',
    'Debian' => 'ntp',
    default  => undef,
  }

  # Ensure the NTP package is installed
  package { $ntp_package:
    ensure => installed,
  }

  # Start and enable the NTP service
  service { 'ntpd':
    ensure  => running,
    enable  => true,
    require => Package[$ntp_package],
  }

  # Define NTP servers based on your requirements
  $ntp_servers = ['0.ca.pool.ntp.org', '1.ca.pool.ntp.org', '2.ca.pool.ntp.org', '3.ca.pool.ntp.org']

  # Configure NTP servers using file_line
  file_line { 'ntp_servers':
    path    => '/etc/ntp.conf',
    line    => $ntp_servers.map |$server| { "server ${server}" },
    match   => '^server\s',
    ensure  => present,
    require => Package[$ntp_package],
  }
}
