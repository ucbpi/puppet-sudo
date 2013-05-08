class sudo::params {
    # defines the list of packages that we require
    $packages = [ 'sudo' ]
    
    # defines where we'll pull the template from by default
    case $::osfamily {
        'RedHat': { 
            case $::operatingsystemrelease {
                /^5\.[0-9]+$/: { $sudoers_template = 'sudo/sudoers.el5.erb'}
                /^6\.[0-9]+$/: { $sudoers_template = 'sudo/sudoers.el6.erb'}
                default: { fail("el${operatingsystemrelease} not support") }
            }
        }
        default: { fail("osfamily '${::osfamily}' not supported") }
    }
    
    # defines where we'll stick the sudoers file
    $sudoers = '/etc/sudoers'
    
    # defines where we'll put the default sudoers file
    $puppet_sudoers = '/etc/sudoers.d/puppet_sudoers'

    # defines the sudoers.d directory
    $sudoers_d = '/etc/sudoers.d'

    $default_sudoers = "puppet_sudoers"

    #
    # File Priorities
    $defaults_ord = '100'
    $user_alias_ord = '110'
    $runas_alias_ord = '120'
    $host_alias_ord = '130'
    $cmnd_alias_ord = '140'
    $entry_ord = '900'
}
