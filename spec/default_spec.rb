require 'spec_helper'
require 'support/resources_helper'
require 'support/split_configuration_helper'

shared_context 'configuration' do |platform, version, backend|
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new platform: platform, version: version
    runner.node.set['pure-ftpd']['backend'] = backend
    runner.converge recipe
  end

  subject { chef_run }
end

describe 'pure-ftpd::default' do
  let(:recipe) { described_recipe }

  context 'requires basic configuration' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge described_recipe }
    subject { -> { chef_run } }

    context 'without backend configuration' do
      it { should raise_error(RuntimeError) }
    end
  end

  %w(pam unix).each do |backend|
    describe "with #{backend} backend" do
      DEB_PLATFORMS.each do |platform, versions|
        context "on #{platform} platform" do
          versions.each do |version|
            context "version #{version}" do
              include_context 'configuration', platform, version, backend
              include_examples 'resources', service_name(platform, backend)
              include_examples 'split configuration', backend
            end
          end
        end
      end

      RPM_PLATFORMS.each do |platform, versions|
        context "on #{platform}" do
          versions.each do |version|
            context "version #{version}" do
              include_context 'configuration', platform, version, backend
              include_examples 'resources', service_name(platform, backend)
            end
          end
        end
      end
    end
  end

  %w(mysql postgresql ldap).each do |backend|
    describe "with #{backend} backend" do
      DEB_PLATFORMS.each do |platform, versions|
        context "on #{platform}" do
          versions.each do |version|
            context "version #{version}" do
              include_context 'configuration', platform, version, backend
              include_examples 'resources', service_name(platform, backend)
              include_examples 'split configuration', backend

              it { should render_file(chef_run.node['pure-ftpd']["#{backend}.conf"]) }
            end
          end
        end
      end

      RPM_PLATFORMS.each do |platform, versions|
        context "on #{platform} platform" do
          versions.each do |version|
            context "version #{version}" do
              include_context 'configuration', platform, version, backend
              include_examples 'resources', service_name(platform, backend)

              it { should include_recipe('yum-epel::default') }
              it { should render_file("#{subject.node['pure-ftpd']['conf_config_dir']}/pure-ftpd.conf") }
              it { should render_file(chef_run.node['pure-ftpd']["#{backend}.conf"]) }
            end
          end
        end
      end
    end
  end
end
