#
# Cookbook Name:: jml-defaults
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

RSpec.describe 'jml-defaults::packages' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    describe 'the default packages' do
      it 'include zsh' do
        expect(chef_run).to install_package('zsh')
      end
      it 'include git' do
        expect(chef_run).to install_package('git')
      end
      it 'installs vim from source' do
        expect(chef_run).to include_recipe 'vim::source'
      end

      context 'as an ovirt guest' do
        let(:runner) do
          ChefSpec::ServerRunner.new(platform: 'centos', version: '7.0') do |n|
            n.set['ovirt_guest'] = true
          end.converge(described_recipe)
        end
        it 'includes open-vm-tools' do
          expect(runner).to install_yum_package('ovirt-guest-agent-common')
        end
      end
    end
  end
end
