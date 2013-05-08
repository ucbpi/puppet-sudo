define sudo::target{
    include sudo::params
    include concat::setup

    concat{ $name:
        path  => "${sudo::params::sudoers_d}/${name}",
        owner => 'root',
        group => 'root',
        mode  => '0440',
    }

    # let's make sure our sudoers.d dir exists before we start
    # building our concat object
    File[$sudo::params::sudoers_d] -> Concat[$name]
}
