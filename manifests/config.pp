class sudo::config {
  # create our sudoers file
  file { '/etc/sudoers':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    content => template($sudo::sudoers_erb)
  }

  file{ '/etc/sudoers.d':
    ensure       => directory,
    owner        => 'root',
    group        => 'root',
    mode         => '0440',
    recurse      => true,
    purge        => true,
    recurselimit => '1',
  }
}
