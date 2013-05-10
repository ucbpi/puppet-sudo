# == Class: sudo
#
# Sudo management class. This class does not need to be called directly, as the
# sudo::entry and sudo::alias defines take care of including it if you dont.
#
class sudo {

  #######
  # Set some parameters based on osfamily and version
  #
  case $::osfamily {

    # RedHat family OSes
    'RedHat':
      {
        $sudoers_d_dir = '/etc/sudoers.d'
        $sudoers = '/etc/sudoers'

        case $::operatingsystemrelease {

          # RedHat 5.x family OSes
          /^5\.[0-9]+$/:
            {
              $sudoers_erb = 'sudo/sudoers.el5.erb'
            }

          # RedHat 6.x family OSes
          /^6\.[0-9]+$/:
            {
              $sudoers_erb = 'sudo/sudoers.el6.erb'
            }

          # Other RedHat OSes
          default:
            {
              $err_rhel_arr = [
                'Class[sudo]',
                ':',
                "Unsupported Redhat version - ${::operatingsystemrelease}"
              ]
              $err_rhel = join( $err_rhel_arr, ' ' )
              fail( $err_rhel )
          }
        }
      }

    # All other OS families
    default:
      {
        fail( "Class[sudo] : Unsupported OS family - ${::osfamily}" )
      }
  }

  include sudo::package, sudo::config

  $default = {
    'target' => 'puppet_sudoers',
  }

  $order = {
    'user_alias'  => '10',
    'runas_alias' => '30',
    'host_alias'  => '50',
    'cmnd_alias'  => '70',
    'entry'       => '90',
  }
}
