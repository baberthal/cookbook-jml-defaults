#
# Cookbook Name:: jml-defaults
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

RSpec.describe 'jml-defaults::user', :vault do
  shared_examples 'adds the correct user' do |pform, version|
    context "on #{pform} #{version}" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: pform, version: version)
          .converge(described_recipe)
      end
      let(:user) { chef_run.node['platform'] }
      let(:sudo_group) do
        chef_run.node['platform_family'] == 'rhel' ? 'wheel' : 'sudo'
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'creates a user with attributes' do
        expect(chef_run).to create_user("#{user}").with(group: "#{user}")
        expect(chef_run).to_not create_user("#{user}").with(group: 'whatever')
      end

      it 'adds that user to the sudo group' do
        expect(chef_run).to modify_group("#{sudo_group}")
          .with(members: ["#{user}"])
      end

      it 'allows morgan@pro to login as the user' do
        expect(chef_run).to render_file("/home/#{user}/.ssh/authorized_keys")
          .with_content(%r{^ssh-rsa [A-Za-z0-9+/=]+ morgan@pro$})
      end
    end
  end

  describe 'jml-defaults::user' do
    platforms = {
      'debian' => ['8.1'],
      'ubuntu' => ['12.04', '14.04'],
      'centos' => ['7.1.1503']
    }
    platforms.each do |platform, versions|
      versions.each do |version|
        include_examples 'adds the correct user', platform, version
      end
    end
  end
end
