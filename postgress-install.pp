class profile::postgresql  {
  $package_name = $facts['os']['family'] ? {
    'RedHat' => 'postgresql-server',
    'Debian' => 'postgresql',
    default  => 'postgresql', # Assuming default for other OS families
  }

  package { $package_name:
    ensure => installed,
  }

  package { 'postgresql-contrib':
    ensure => installed,
  }

  package { 'postgresql-client':
    ensure => installed,
  }

  exec { 'initdb':
    command     => '/usr/bin/postgresql-setup initdb',
    refreshonly => true,
  }

  service { 'postgresql':
    ensure  => running,
    enable  => true,
    require => [Package[$package_name], Exec['initdb']],
  }

  file_line { 'allow_all_users_ipv4':
    path    => '/etc/postgresql/14/main/pg_hba.conf',
    line    => 'host    all             all             0.0.0.0/0            md5',
    match   => '^host\s+all\s+all\s+0\.0\.0\.0/0\s+md5$',
    ensure  => present,
    require => Service['postgresql'],

  }

  file_line { 'all_listen_address':
  path    => '/etc/postgresql/14/main/postgresql.conf,
  line    => 'listen_address=*',
  match   => '^#listen_address = ',
  after   => '^#.*$', # This makes sure the line is added after any existing commented lines

  }



  exec { 'set_postgres_password':
    command => 'sudo -u postgres psql -c "ALTER USER postgres PASSWORD \'TPSrep0rt!\';"',
    unless  => 'sudo -u postgres psql -c "SELECT 1" | grep -q 1',
    require => Service['postgresql'],
    refreshonly => true,
    path => '/usr/bin/sudo',
  }

 }
