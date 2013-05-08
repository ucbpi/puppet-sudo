define sudo::target{
    include concat::setup

    concat{ $title:
        path  => "${sudo::sudoers_d_dir}/${title}",
        owner => 'root',
        group => 'root',
        mode  => '0440',
    }

    # let's make sure our sudoers.d dir exists before we start
    # building our concat object
    File[$sudo::sudoers_d_dir] -> Concat[$name]
}
