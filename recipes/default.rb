#
# Cookbook Name:: pure-ftpd
# Attributes:: pure-ftp
#
# Copyright 2013, Gabor Nagy
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Validates type of backend.
fail "Backend should be one of [#{backends.join(', ')}]." unless backends.include? selected_backend

case node['platform_family']
when 'rhel', 'fedora'
  # Names of packages are pure-ftpd and pure-ftpd-selinux.
  # Pure-FTPd is available from EPEL repository only.
  include_recipe 'yum-epel'
end

package node['pure-ftpd']['package']

group node['pure-ftpd']['group']
user node['pure-ftpd']['user'] do
  gid node['pure-ftpd']['group']
  home node['pure-ftpd']['home']
  shell '/bin/false'
end

case node['platform_family']
when 'rhel', 'fedora'
  # rpm package uses single file configuration
  template "#{node['pure-ftpd']['config_dir']}/pure-ftpd.conf" do
    source 'pure-ftpd.conf.erb'
    user 'root'
    group 'root'
    mode '0600'
    notifies :restart, "service[#{node['pure-ftpd']['package']}]", :delayed
  end
when 'debian'
  # deb package(s) use(s) split configuration
  options.each do |name, value|
    file "#{node['pure-ftpd']['conf_config_dir']}/#{name}" do
      content value
      action :delete unless value
    end
  end

  config_content = standard_backend? ? 'yes' : node['pure-ftpd']["#{selected_backend}.conf"]
  file "#{node['pure-ftpd']['conf_config_dir']}/#{node['pure-ftpd']['auth'][selected_backend]['filename']}" do
    content config_content
    action :create
  end
  link_authentication_backend_configuration selected_backend, :create
  disabled_backends.each do |disabled_backend|
    link_authentication_backend_configuration disabled_backend, :delete
    file "#{node['pure-ftpd']['conf_config_dir']}/#{node['pure-ftpd']['auth'][disabled_backend]['filename']}" do
      action :delete
    end
  end
end

# Configuration files for backends are platform independent.
if database_backend? && selected_backend != 'puredb'
  # Blanks disabled queries.
  node['pure-ftpd'][selected_backend]['disabled_queries'].each do |query|
    node.default['pure-ftpd'][selected_backend]['queries'][query] = nil
  end
  # Config file contains sensitive information, only root should have (read) access.
  template_name = "#{selected_backend}.conf.erb"
  template node['pure-ftpd']["#{selected_backend}.conf"] do
    source template_name
    user 'root'
    group 'root'
    mode '0600'
  end
end

# Creates virtual users' homes.
directory node['pure-ftpd']['virtual_users_root'] do
  owner node['pure-ftpd']['user']
  group node['pure-ftpd']['group']
  mode '0775'
  action :create
end if node['pure-ftpd']['virtual_users_root']

service 'pure-uploadscript' do
  supports start: true, stop: true
  action [:enable, :start]
  only_if { node['pure-ftpd']['options']['enabled'].include? 'CallUploadScript' }
end

# Enables and restarts Pure-FTPd service.
service node['pure-ftpd']['package'] do
  supports status: true, restart: true
  action [:enable, :start]
end
