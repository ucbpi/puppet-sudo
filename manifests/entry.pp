# sudo::entry{ 'ossunix-root':
#    user       => '%ossunix',
#    nopasswd => true,
#    }
define sudo::entry ( $cmnd = 'ALL',
                     $cmnds = [ ],
                     $user = 'UNDEF',
                     $users = [ ],
                     $nopasswd = false,
                     $target = 'UNDEF', # sudoers file target
                     $order = '-1' ) # rule order
{
    include sudo::params

    #
    # Parameter Validation
    validate_array( $users )
    validate_array( $cmnds )
    validate_re( $user, '^(%?[a-z]+|UNDEF)$' )
    validate_string( $cmnd )
    validate_bool( $nopasswd )
    validate_re( $target, '^(\w+|UNDEF)$' )
    validate_re( $order, '^(?:[0-9]{3}|-1)$' ) # 0-999, -1 (default)

    #
    # Parameter Logic
    # users array takes precedence over user string. dont judge the
    # formatting. it's beautiful.
    if size($users) > 0 
    { $real_users = $users }
    elsif size($user) > 0 and $user != 'UNDEF'
    { $real_users = [ "$user" ] }
    elsif size($users) > 0 and $user != 'UNDEF'
    { warning("\$user and \$users both specified. \$user ignored") }
    else { fail("you must specify either \$user or \$users") }

    # same thing here, but with commands
    if size($cmnds) > 0  # use cmnds array if populated
    { $real_cmnds = $cmnds }
    elsif size($cmnd) > 0 and $cmnd != 'UNDEF'  # use cmnd string instead
    { $real_cmnds = [ "$cmnd" ] }

    if size($cmnds) > 0 and $cmnd != 'UNDEF'
    { warning("\$cmnd and \$cmnds both specified. \$cmnd ignored") }

    if size($cmnds) == 0 and ( $cmnd == 'UNDEF' or $cmnd == '' )
    { fail("you must specify either \$cmnd or \$cmnds") }

    # use a default target, if not given a valid one
    $real_target = $target ? { 
        'UNDEF' => $sudo::params::default_sudoers,
        default => $target
    }

    # use a default order, if not given a valid one
    $real_order = $order ? {
        '-1'    => $sudo::params::user_alias_ord,
        default => $order 
    }

    $real_nopasswd = $nopasswd

    #
    # Resource Declarations
    if !defined(Sudo::Target[$real_target]) {sudo::target{ $real_target: }}

    concat::fragment { "sudoers_${real_target}_ca_${name}":
        order   => $real_order,
        content => template('sudo/entry.erb'),
        target  => $real_target,
    }
}
