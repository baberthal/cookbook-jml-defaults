#
# Cookbook Name:: jml-defaults
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

RSpec.describe 'jml-defaults::dotfiles' do
  context 'When all attributes are default, on an unspecified platform' do
    cached(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
    let(:user) { chef_run.node['platform'] }

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

    it 'checks out the dotfiles repo into the home directory' do
      expect(chef_run).to sync_git("/home/#{user}/dotfiles")
        .with(repository: 'https://github.com/baberthal/dotfiles.git')
    end

    it 'links the necessary dotfiles' do
      expect(chef_run).to create_link("/home/#{user}/.vim")
        .with(to: "/home/#{user}/dotfiles/vim")
      expect(chef_run).to create_link("/home/#{user}/.oh-my-zsh")
        .with(to: "/home/#{user}/dotfiles/oh-my-zsh")
      expect(chef_run).to create_link("/home/#{user}/.zextra")
        .with(to: "/home/#{user}/dotfiles/zextra")
    end

    describe 'vimrc' do
      it 'creates itself from a template' do
        expect(chef_run).to create_template("/home/#{user}/.vimrc")
      end
    end

    describe 'zdots' do
      it 'creates zshrc from a template' do
        expect(chef_run).to create_template("/home/#{user}/.zshrc")
      end
      it 'creates cookbook_file zshenv' do
        expect(chef_run).to create_cookbook_file("/home/#{user}/.zshenv")
      end
    end
  end
end
