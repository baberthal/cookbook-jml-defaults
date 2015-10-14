require 'spec_helper'

RSpec.describe 'jml-defaults::default' do
  def undotify(str)
    str.tr('.', '')
  end

  def destination(str)
    str = undotify(str)
    %w(vimrc zshrc).include?(str) ? "#{str}.linux" : str
  end

  shared_examples 'dotfile symlinks' do |target, user_home|
    describe file("#{user_home}/#{target}") do
      let(:dest) { destination(target) }
      it { is_expected.to be_symlink }
      it { is_expected.to be_linked_to "#{user_home}/dotfiles/#{dest}" }
    end
  end

  shared_examples 'dotfile templates' do |f, user_home|
    describe file("#{user_home}/#{f}") do
      it { is_expected.to be_file }
      it { is_expected.to exist }
    end
  end

  shared_examples 'user config' do |u|
    homedir = ->(d) { d == 'root' ? '/root' : "/home/#{d}" }
    describe user(u) do
      let(:home_dir) { homedir.call(u) }
      it { is_expected.to exist }
      it { is_expected.to belong_to_group u }
      it { is_expected.to have_home_directory home_dir }
      it { is_expected.to have_login_shell '/bin/zsh' }
    end
  end

  describe 'user' do
    users = os[:family] == 'redhat' ? %w(root centos) : %w(root ubuntu)
    users.each do |user|
      include_examples 'user config', user
    end
  end

  describe 'cloning and linking dotfiles' do
    dotfile_links = ['.vim', '.oh-my-zsh']
    dotfiles = ['.zshrc', '.vimrc', '.zshenv']
    users = %w(/root)
    os[:family] == 'redhat' ? users << '/home/centos' : users << '/home/ubuntu'
    users.each do |u|
      dotfile_links.each do |f|
        include_examples 'dotfile symlinks', f, u
      end
      dotfiles.each do |f|
        include_examples 'dotfile templates', f, u
      end
    end
  end

  describe 'packages' do
    describe package('zsh') do
      it { is_expected.to be_installed }
    end
    describe package('git') do
      it { is_expected.to be_installed }
    end
    describe file('/usr/local/bin/vim') do
      it { is_expected.to exist }
      it { is_expected.to be_executable }
    end
  end
end
