# == Class: sudo::config
#
# Sets up our sudo configuration files for us, and ensures our sudoers.d
# directory is prepared for use. This class should not be called directly.
#
class sudo::config {
  include sudo

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
