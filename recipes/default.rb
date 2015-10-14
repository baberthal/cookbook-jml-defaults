#
# Cookbook Name:: jml-defaults
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
include_recipe 'apt::default' if platform_family?('debian')
include_recipe 'chef-vault'
include_recipe 'jml-defaults::packages' unless platform? 'fedora'
include_recipe 'jml-defaults::user' if node['jml-defaults']['admin_user']
include_recipe 'jml-defaults::dotfiles'
