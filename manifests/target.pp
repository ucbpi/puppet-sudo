# == Define: sudo::target
#
# Sets up our concat target for use by our sudo::alias and sudo::entry defined
# types.  This define should not be called directly
#
define sudo::target{
  include sudo
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
