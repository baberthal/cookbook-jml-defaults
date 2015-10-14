#
# Cookbook Name:: jml-defaults
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

RSpec.describe 'jml-defaults::default', :vault do
  shared_examples 'includes apt::default' do |platform, version|
    context "on #{platform}, #{version}" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: platform, version: version)
          .converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'includes the apt::default recipe' do
        expect(chef_run).to include_recipe('apt::default')
      end
    end
  end

  describe 'jml-defaults::default' do
    platforms = {
      'debian' => ['8.1'],
      'ubuntu' => ['12.04', '14.04', '15.04']
    }
    platforms.each do |platform, versions|
      versions.each do |version|
        include_examples 'includes apt::default', platform, version
      end
    end
  end

  describe 'included recipes' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
    subject { chef_run }
    it { is_expected.to include_recipe 'chef-vault' }
    it { is_expected.to include_recipe 'jml-defaults::packages' }
    it { is_expected.to include_recipe 'jml-defaults::user' }
    it { is_expected.to include_recipe 'jml-defaults::dotfiles' }
  end
end
