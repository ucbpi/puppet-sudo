# sudo Module #

This module provides mechanisms to manage your sudoers entries 

# Examples #

<pre><code>
  sudo::alias { 'webmaster commands':
    type   => 'cmnd',
    value  => [ '/sbin/service httpd *', '/sbin/service nginx *' ],
    name   => 'CMD_WEBMASTER',
    target => 'standard',
  }

  sudo::alias { 'su to erp user':
    type   => 'cmnd',
    value  => '/usr/bin/sudo su - app_erp,/usr/bin/sudo su -l',
    name   => 'CMD_SU_APP_ERP',
    target => 'app_erp',
  }

  sudo::entry { 'webmaster access':
    cmnd     => 'CMD_WEBMASTER',
    user     => '%webmaster',
    target   => 'standard',
  }

  sudo::entry { 'erp acces':
    cmnd     => 'CMD_SU_APP_ERP',
    user     => '%erp_admins,
    target   => 'app_erp',
    nopasswd => true,
  }
</code></pre>
 

License
-------

None

Contact
-------

Aaron Russo <arusso@berkeley.edu>

Support
-------

Please log tickets and issues at the
[Projects site](https://github.com/arusso/puppet-sudo/issues/)
