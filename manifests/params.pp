class transmission::params {

  $packages = [
    'transmission-cli',
    'transmission-common',
    'transmission-daemon',
  ]

  #if $facts['os']['release']['full'] == '16.04' {
  if ($::operatingsystem == 'Ubuntu' and versioncmp($::operatingsystemrelease, '16.04')) {
    $use_systemd = true
    $home_dir    = "/home/${::transmission::user}/.config/transmission-daemon"
    $config_dir  = "${::transmission::params::home_dir}"
    $stop_cmd    = '/bin/systemctl stop transmission-daemon'
    $start_cmd   = '/bin/systemctl start transmission-daemon'
  } elsif $facts['os']['lsb']['distid'] == "Raspbian" and $facts['os']['lsb']['distcodename'] == "jessie" {
    $use_systemd = true
    $home_dir    = '/var/lib/transmission-daemon'
    $config_dir  = '/etc/transmission-daemon'
    $stop_cmd    = '/bin/systemctl stop transmission-daemon'
    $start_cmd   = '/bin/systemctl start transmission-daemon'
  } else {
    $use_systemd = false
    $home_dir    = '/var/lib/transmission-daemon'
    $config_dir  = '/etc/transmission-daemon'
    $stop_cmd    = '/usr/sbin/service transmission-daemon stop'
    $start_cmd   = '/usr/sbin/service transmission-daemon start'
  }

  if $::transmission::rpc_bind_address != undef {
    $rpc_bind = $::transmission::rpc_bind_address
  } else {
    $rpc_bind = $::transmission::bind_address_ipv4
  }

  if $::transmission::service_ensure != 'running' {
    $cron_ensure = absent
  } elsif $::transmission::blocklist_url != undef {
    $cron_ensure = present
  } else {
    $cron_ensure = absent
  }

  if $::transmission::rpc_enable_auth == true {
    $remote_command_auth = "-n ${::transmission::rpc_username}:${::transmission::rpc_password}"
  } else {
    $remote_command_auth = ''
  }

}
