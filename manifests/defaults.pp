# == Class: openstacklib::defaults
#
# Default configuration for all openstack-puppet module.
#
# This file is loaded in the params.pp of each class.
#
class openstacklib::defaults (
  $python_major = undef,
  $python_minor = undef,
) {

  # TODO(tobias-urdin): Remove this in the T release when we remove
  # all Puppet 4 related code.
  if versioncmp($::puppetversion, '5.0.0') < 0 {
    warning('OpenStack modules support for Puppet 4 is deprecated \
and will be officially unsupported in the T release')
  }

  # allow the user to override the python versions to be used
  if ! $python_major and ! $python_minor {
    if ($::os['family'] == 'Debian') {
      $pyvers = '3'
      $pyver3 = '3'
    } elsif ($::os['name'] == 'Fedora') or
            ($::os['family'] == 'RedHat' and Integer.new($::os['release']['major']) > 7) {
      $pyvers = '3'
      $pyver3 = '3.6'
    } else {
      $pyvers = ''
      $pyver3 = '2.7'
    }
  } else {
    $pyvers = $python_major ? {
      '2' => '',
      '3' => '3',
    }
    $pyver3 = "${python_major}.${python_minor}"
  }
}
