#
# Cookbook Name:: jml-defaults
# Recipe:: dotfiles
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_root = node['jml-defaults']['dotfiles']['include_root']
users_need_dotfiles = [node['jml-defaults']['dotfiles']['users']].flatten
users_need_dotfiles << 'root' if include_root

user 'root' do
  shell node['jml-defaults']['dotfiles']['shell']
  action :modify
end

ssh_keys = data_bag_item('ssh', 'authorized_keys')
ssh_keys.delete('id')

ssh_keys.each do |name, ssh_key|
  ssh_authorize_key name do
    key ssh_key['key']
    user 'root'
  end
end

home_dir_for = ->(user) { user == 'root' ? '/root' : "/home/#{user}" }

users_need_dotfiles.each do |username|
  git "#{home_dir_for.call(username)}/dotfiles" do
    repository node['jml-defaults']['dotfiles']['repo']
    enable_submodules true
    user username
    action :sync
  end

  link 'vim' do
    group username
    link_type :symbolic
    owner username
    target_file "#{home_dir_for.call(username)}/.vim"
    to "#{home_dir_for.call(username)}/dotfiles/vim"
  end

  template 'vimrc' do
    group username
    owner username
    source 'vimrc.erb'
    mode 0755
    path "#{home_dir_for.call(username)}/.vimrc"
    action :create
    variables plugins: node['jml-defaults']['vim']['plugins']
    helpers(VundlePluginHelpers)
  end

  template 'zshrc' do
    group username
    owner username
    source 'zshrc.erb'
    mode 0755
    path "#{home_dir_for.call(username)}/.zshrc"
    action :create
    variables plugins: node['jml-defaults']['zsh']['plugins']
  end

  cookbook_file 'zshenv' do
    group username
    owner username
    mode 0755
    source 'zshenv'
    path "#{home_dir_for.call(username)}/.zshenv"
  end

  link 'oh-my-zsh' do
    group username
    link_type :symbolic
    owner username
    target_file "#{home_dir_for.call(username)}/.oh-my-zsh"
    to "#{home_dir_for.call(username)}/dotfiles/oh-my-zsh"
  end

  link 'zextra' do
    group username
    link_type :symbolic
    owner username
    target_file "#{home_dir_for.call(username)}/.zextra"
    to "#{home_dir_for.call(username)}/dotfiles/zextra"
  end
end
