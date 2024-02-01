class profile::ssh (
  Integer $port = 22
) {

  package { 'openssh':
    ensure => 'present',
  }

  service { 'sshd':
    ensure => 'running',
    require => Package['openssh'],
  }

  file_line { 'SSH port':
    path    => '/etc/ssh/sshd_config',
    line    => "Port ${port}",
    match   => '^Port',
    notify  => Service['sshd'],
    require => Package['openssh'],
  }
}
