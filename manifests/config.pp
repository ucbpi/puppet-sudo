class sudo::config {

  case $::osfamily {
    'RedHat': {
      case $::operatingsystemrelease {
        /^5\.[0-9]+$/: {
          $sudoers_erb = 'sudo/sudoers.el5.erb'
        }
        /^6\.[0-9]+$/: {
          $sudoers_erb = 'sudo/sudoers.el6.erb'
        }
        default: {
          $err_rhel_arr = [
            'Class[sudo::config]',
            ':',
            "Unsupported Redhat version - ${::operatingsystemrelease}"
          ]
          $err_rhel = join( $err_rhel_arr, ' ' )
          fail( $err_rhel )
        }
      }
    }
    default: {
      fail( "Class[sudo::config] : Unsupported OS family - ${::osfamily}" )
    }
  }

  # create our sudoers file
  file { '/etc/sudoers':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    content => template($sudoers_erb)
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
