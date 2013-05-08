# == Class: sudo
#
# Manages sudoers configuration on a host. 
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { sudo:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2011 Your name here, unless otherwise noted.
#
class sudo ( $sudoers_template = 'UNDEF' ) {
    include sudo::params

    #
    # Parameter Validation
    validate_string( $sudoers_template )

    #
    # Parameter Logic
    $real_sudoers_template = $sudoers_template ? {
        'UNDEF' => $sudo::params::sudoers_template,
        default => $sudoers_template,
    }

    #
    # Resource Declarations 

    # sudo class handles ensure sudo is installed
    package{ $sudo::params::packages: ensure => 'installed' }

    # create our sudoers file
    file { $sudo::params::sudoers:
        owner   => 'root',
        group   => 'root',
        mode    => '0440',
        content => template($real_sudoers_template),
        ensure  => 'file',
    }
    
    file{ $sudo::params::sudoers_d:
        owner        => 'root',
        group        => 'root',
        mode         => '0440',
        ensure       => 'directory',
        recurse      => true,
        purge        => true,
        recurselimit => '1',
    }
}
