#
# Cookbook Name:: jml-defaults
# Recipe:: user
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

default_attrs = {
  group: node['jml-defaults']['admin_user']['group'],
  user: node['jml-defaults']['admin_user']['user'],
  shell: node['jml-defaults']['admin_user']['shell'],
  dotfiles_repo: node['jml-defaults']['admin_user']['dotfiles_repo'],
  password: chef_vault_item('passwords', 'local'),
  sudo_group: node['jml-defaults']['admin_user']['sudo_group']
}

group default_attrs[:group]

user default_attrs[:user] do
  group default_attrs[:group]
  shell default_attrs[:shell]
  action :create
  manage_home true
  home "/home/#{default_attrs[:user]}"
  password default_attrs[:password]['password']
end

group default_attrs[:sudo_group] do
  action :modify
  append true
  members default_attrs[:user]
end

ssh_keys = data_bag_item('ssh', 'authorized_keys')
ssh_keys.delete('id')

ssh_keys.each do |name, auth_key|
  ssh_authorize_key name do
    key auth_key['key']
    user default_attrs[:user]
  end
end
