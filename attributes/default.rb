default['jml-defaults'] = {
  'shell' => '/bin/zsh',
  'zsh' => {
    'plugins' => value_for_platform_family(
      'rhel' => %w(git yum systemd),
      'debian' => %w(git apt)
    )
  }
}

default['jml-defaults']['admin_user'] = {
  'user' => node['platform'],
  'group' => node['platform'],
  'shell' => '/bin/zsh',
  'sudo_group' => platform_family?('rhel') ? 'wheel' : 'sudo'
}

default['vim']['install_method'] = 'source'
default['admin_user'] = node['jml-defaults']['admin_user']['user'] || 'root'
