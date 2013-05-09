# sudo::entry{ 'ossunix-root':
#    user       => '%ossunix',
#    nopasswd => true,
#    }
define sudo::entry ( $cmnd = 'ALL',
                      $user = undef,
                      $nopasswd = false,
                      $target = undef,
                      $order = undef
) {

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
