# == Define: sudo::entry
#
# Defines a sudo rule
#
# === Parameters:
#
# [*cmnd*]
#
# a comma separated string or array of commands that the user should be allowed
# to execute.  paths must be fully qualified for all non-builtin commands.
#
# [*user*]
#
# an array of user or groups (or any combination) that may run these commands
#
# [*nopasswd*]
#
# if set to true, the user specified will not need to enter their password to
# run sudo commands. default is false.
#
# [*target*]
#
# file target to put the sudo rules in within the sudoers.d directory.  defaults
# to puppet_sudoers.
#
# [*order*]
#
# the order within the file that the rule should appear.  not likely to be
# needed, but if you think you might, take a look at the init.pp inline
# documentation for more info.
#
define sudo::entry ( $cmnd = 'ALL',
                      $user = undef,
                      $nopasswd = false,
                      $target = undef,
                      $order = undef
) {
  include sudo

  if is_array( $cmnd ) {
    validate_string( $cmnd )
    $cmnd_r = $cmnd
  } else {
    $cmnd_r = split( $cmnd, ',' )
  }

  if is_array( $user ) {
    validate_string( $user )
    $user_r = $user
  } else {
    $user_r = split( $user, ',' )
  }

  validate_bool( $nopasswd )

  $target_r = $target ? {
    undef   => $sudo::default[target],
    default => $target,
  }

  # use a default order, if not given a valid one
  $order_r = $order ? {
    undef    => $sudo::order[entry],
    default => lead($order, 2),
  }
  validate_re( $order_r, '^[0-9]{2}$' )

  $nopasswd_r = $nopasswd

  #
  # Resource Declarations
  if !defined(Sudo::Target[$target_r]) { sudo::target{ $target_r: } }

  concat::fragment { "sudoers_${target_r}_entry_${name}":
    order   => $order_r,
    content => template('sudo/entry.erb'),
    target  => $target_r,
  }
}
