default['jml-defaults']['shell'] = '/bin/zsh'

plugins = %w(git)

if platform_family? 'rhel'
  plugins << 'yum'
elsif platform_family? 'debian'
  plugins << 'apt'
end

plugins << 'systemd' if node['init_package'] == 'systemd'

default['jml-defaults']['zsh']['plugins'] = plugins

default['jml-defaults']['admin_user'] = {
  'user' => node['platform'],
  'group' => node['platform'],
  'shell' => '/bin/zsh',
  'sudo_group' => platform_family?('rhel') ? 'wheel' : 'sudo'
}

default['vim']['install_method'] = 'source'
default['admin_user'] = node['jml-defaults']['admin_user']['user'] || 'root'
