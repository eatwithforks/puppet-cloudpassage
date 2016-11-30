# Cloud Passage agent installation module
#
# Params
#
# agent_key       = the agent registration key you use to register the node
# audit_mode      = Controls the Halo Agent's "read-only" attribute
# destination_dir = (Windows only) Controls where we'll download the installer EXE
# manage_repos    = (Linux only) set to true by default, will add cloudpassage package repo for install
# package_ensure  = controls the package resource's "ensure" attribute
# package_file    = (Windows only) controls the filename of the installer EXE
# package_name    = controls the package resource's "name" attribute
# package_url     = (Windows only) base URL from which we'll download the installer EXE
# repo_ensure     = (Linux only) controls the apt or yum repo's "ensure" attribute
# service_name    = the name of the service
# server_label    = unique identifer of the VM
# tags            = facts or values to use as tags for this node, if empty, tags will not be set
#
class cloudpassage(
  $agent_key       = $::cloudpassage::params::agent_key,
  $audit_mode      = $::cloudpassage::params::audit_mode,
  $destination_dir = $::cloudpassage::params::destination_dir,
  $manage_repos    = $::cloudpassage::params::manage_repos,
  $package_ensure  = $::cloudpassage::params::package_ensure,
  $package_file    = $::cloudpassage::params::package_file,
  $package_name    = $::cloudpassage::params::package_name,
  $package_url     = $::cloudpassage::params::package_url,
  $repo_ensure     = $::cloudpassage::params::repo_ensure,
  $service_enable  = $::cloudpassage::params::service_enable,
  $service_ensure  = $::cloudpassage::params::service_ensure,
  $service_name    = $::cloudpassage::params::service_name,
  $server_label    = $::cloudpassage::params::server_label,
  $tags            = $::cloudpassage::params::tags,
) inherits ::cloudpassage::params {
  validate_string($agent_key)
  validate_bool($audit_mode)
  validate_string($package_ensure)
  validate_string($package_name)
  validate_string($service_name)
  validate_bool($service_enable)
  validate_bool($service_ensure)
  validate_string($server_label)
  validate_string($tags)

  if $::kernel == 'Linux' {
    validate_bool($manage_repos)
    validate_string($repo_ensure)

    if $manage_repos == true {
      case $::operatingsystem {
        /(?i:debian|ubuntu)/:        { include cloudpassage::apt }
        /(?i:redhat|centos|fedora)/: { include cloudpassage::yum }
        default: {}
      }
    }
  } elsif $::kernel == 'windows' {
    validate_absolute_path($destination_dir)
    validate_string($package_file)
    validate_string($package_url)

    if $package_ensure == 'absent' {
      $uninstall_options = ['/S']
    } else {
      $uninstall_options = undef
    }
  }

  if $package_ensure == 'absent' {
    include cloudpassage::service, cloudpassage::install
    Class['cloudpassage::service'] ~> Class['cloudpassage::install']
  } else {
    include cloudpassage::install, cloudpassage::config, cloudpassage::service
    Class['cloudpassage::install'] ~> Class['cloudpassage::config'] ~> Class['cloudpassage::service']
  }
}
