define sudo::host_alias ( $hosts,
                          $target = undef,
                          $order = undef )
{
  include sudo
  $err_class_name = "Sudo::Host_alias[${title}]"

  if is_array( $hosts ) { $hosts_r = $hosts }
  else { $hosts_r = split( $hosts, '[,|:]' ) }

  case $title {
    /^[A-Z][A-Z0-9_]*$/: { $alias_name_r = $title }
    default: {
      $err_bad_title_arr = [ $err_class_name,
                              ':',
                              "title is invalid - ${title}" ]
      $err_bad_title = join( $err_bad_title_arr, ' ')
      fail( $err_bad_title )
    }
  }

  if $target {
    case downcase($target) {
      /^[a-z][a-z0-9_]*$/: { $target_r = downcase($target) }
      default: {
        $err_bad_target_arr = [ $err_class_name,
                                ':',
                                "target is invalid - ${target}" ]
        $err_bad_target = join( $err_bad_target_arr, ' ')
        fail( $err_bad_target )
      }
    }
  } else {
    $target_r = $sudo::default[target]
  }

  case $order {
    /^[0-9]+$/: { $order_r = lead( $order, 2 ) }
    undef: { $order_r = lead($sudo::order[hostalias], 2) }
    default: {
      $err_bad_order_arr = [ $err_class_name, ':',
                              "order is invalid - ${order}" ]
      $err_bad_order = join( $err_bad_order_arr, ' ' )
      fail( $err_bad_order )
    }
  }

  #
  # Resource Declarations
  if ! defined( Sudo::Target[$target_r] ) { sudo::target{$target_r: } }

  $alias_erb = 'Host_Alias <% @alias_name_r -%> = <%= @hosts_r.join(\',\') %>'
  concat::fragment { "sudoers_${target_r}_ha_${alias_name_r}":
      order   => $order_r,
      content => inline_template($alias_erb),
      target  => $target_r,
  }
}
