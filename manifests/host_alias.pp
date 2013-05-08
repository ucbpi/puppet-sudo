define sudo::host_alias ( $hosts, 
                          $target = 'UNDEF',
                          $order = '-1' )
{
    include sudo::params

    #
    # Parameter Validation
    validate_re( $name, '^[A-Z][A-Z0-9_]*$' )
    validate_array( $hosts )
    validate_re( $target, '^\w+$' )
    validate_re( $order, '^(?:[0-9]{3}|-1)$' ) # 0-999, -1 (default)

    #
    # Parameter Logic
    $real_target = $target ? { 
        'UNDEF' => $sudo::params::default_sudoers,
        default => $target
    }

    $real_order = $order ? {
        '-1'    => $sudo::params::host_alias_ord,
        default => $order 
    }

    #
    # Resource Declarations
    if ! defined( Sudo::Target[$real_target] ) { sudo::target{$real_target: } }

    concat::fragment { "sudoers_${real_target}_ha_${name}":
        order   => $real_order,
        content => template('sudo/host_alias.erb'),
        target  => $real_target,
    }
}
