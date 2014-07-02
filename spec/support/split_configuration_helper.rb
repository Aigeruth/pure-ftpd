require 'spec_helper'

shared_context 'split configuration' do |backend|
  let(:unused_backends) { subject.node['pure-ftpd']['auth'].keys - [backend] }
  let(:conf_config_dir) { subject.node['pure-ftpd']['conf_config_dir'] }
  let(:auth_config_dir) { subject.node['pure-ftpd']['auth_config_dir'] }
  let(:enabled_options) { subject.node['pure-ftpd']['options']['enabled'] }
  let(:disabled_options) { subject.node['pure-ftpd']['options']['disabled'] }
  let(:deleted_files) do
    subject.node['pure-ftpd']['options'].dup.reject { |k, v| %w(enabled disabled).include?(k) || v }.keys
  end
  let(:config_files) do
    subject.node['pure-ftpd']['options'].dup.reject { |k, v| %w(enabled disabled).include?(k) || !v }.keys
  end
  let(:backend_params) { subject.node['pure-ftpd']['auth'] }

  it 'creates files for settings' do
    (enabled_options + disabled_options).each do |option|
      should create_file("#{conf_config_dir}/#{option}")
    end
  end

  it 'removes unnecessary files' do
    deleted_files.each { |option| should delete_file("#{conf_config_dir}/#{option}") }
  end

  it 'sets configurations' do
    config_files.each { |option| should create_file("#{conf_config_dir}/#{option}") }
  end

  it 'create config file for the selected backend' do
    should create_file(File.join conf_config_dir, backend_params[backend]['filename'])
  end

  it 'removes files for disabled backends' do
    unused_backends.each { |unused_backend| should delete_file(File.join conf_config_dir, backend_params[unused_backend]['filename']) }
  end

  it 'links the backend' do
    should create_link(File.join subject.node['pure-ftpd']['auth_config_dir'], "#{backend_params[backend]['priority']}#{backend_params[backend]['name']}")
  end

  it 'removes links for unused backends' do
    unused_backends.each { |b| should delete_link(File.join auth_config_dir, "#{backend_params[b]['priority']}#{backend_params[b]['name']}") }
  end
end
