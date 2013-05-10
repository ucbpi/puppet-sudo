# == Class: sudo::package
#
# Installs the sudo package.  This class should not be called directly.
#
class sudo::package {
  package { 'sudo': ensure => installed }
}
