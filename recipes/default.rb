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

ftp_service = 'pure-ftpd' 

# Validates type of backend.
# TODO: support multiple backends in the same time and ExtAuth
backends = ["ldap", "mysql", "postgresql", "pam", "unix"]

raise "Backend should be one of [#{backends.join(', ')}]." unless backends.include? node['pure-ftpd']['backend']

# If backend is supported, then that authentication type should be enabled.
node.default['pure-ftpd']['auth'][node['pure-ftpd']['backend']]['enabled'] = "yes"


case node['platform']
when "debian", "ubuntu"
  # Names of packages are pure-ftpd, pure-ftpd-backend-ldap, pure-ftpd-backend-mysql, pure-ftpd-backend-postgresql.
  unless ["pam", "unix"].include? node['pure-ftpd']['backend']
    ftp_service += node['pure-ftpd']['backend'] ? "-#{node['pure-ftpd']['backend']}" : ""
  end
when "redhat", "centos", "scientific", "fedora", "amazon", "oracle"
  # Names of packages are pure-ftpd and pure-ftpd-selinux.
  # Pure-FTPd is available from EPEL repository only.
  include_recipe "yum::epel"
end

package ftp_service

group node['pure-ftpd']['group']
user node['pure-ftpd']['user'] do
  gid   node['pure-ftpd']['group']
  home  node['pure-ftpd']['home']
  shell "/bin/false"
end

case node['platform']
when "debian", "ubuntu"
  options = node['pure-ftpd']['options'].dup.reject { |k,_| %w(enabled disabled).include? k }.to_a
  options += node['pure-ftpd']['options']['enabled'].map { |k| [k, "yes"] }
  options += node['pure-ftpd']['options']['disabled'].map { |k| [k, "no"] }

  options.each do |name, value|
    file "#{node['pure-ftpd']['conf_config_dir']}/#{name}" do
      content value
      action :delete unless value
    end
  end
  # Creates symlinks in auth/ to enable authentication type. Removes if it is disabled.
  # Creates symlink only for the selected backend.
  node['pure-ftpd']['auth'].keys.each do |auth|
    # Creates parameter file with the right content.
    file "#{node['pure-ftpd']['conf_config_dir']}/#{node['pure-ftpd']['auth'][auth]['filename']}" do
      content node['pure-ftpd']["#{auth}.conf"]
      action :create
      only_if { node['pure-ftpd']['auth'][auth]['enabled'] == "yes" and not ["pam", "unix"].include?(auth) }
    end
    file "#{node['pure-ftpd']['conf_config_dir']}/#{node['pure-ftpd']['auth'][auth]['filename']}" do
      action :delete
      only_if { node['pure-ftpd']['auth'][auth]['enabled'] == "no" and not ["pam", "unix"].include?(auth) }
    end
    # Filename pattern: piority + auth_name -> (config) filename
    link "#{node['pure-ftpd']['auth_config_dir']}/#{node['pure-ftpd']['auth'][auth]['priority']}#{node['pure-ftpd']['auth'][auth]['auth_name']}" do
      to "#{node['pure-ftpd']['conf_config_dir']}/#{node['pure-ftpd']['auth'][auth]['filename']}"
      action :delete if node['pure-ftpd']['auth'][auth]['enabled'] == "no"
    end if auth == node['pure-ftpd']['backend']
  end

when "redhat", "centos", "scientific", "fedora", "amazon", "oracle"
  # Creates configuration file.
  template "#{node['pure-ftpd']['config_dir']}/pure-ftpd.conf" do
    source "pure-ftpd.conf.erb"
    user   "root"
    group  "root"
    mode   "0600"
  end
end

# Configuration files for backends are platform independent.
["mysql", "postgresql"].each do |backend|
  puts node['pure-ftpd']['backend']+ ' ' + backend
  puts !!(node['pure-ftpd']['backend'].eql? backend)
  if node['pure-ftpd']['backend'].eql? backend
    # Blanks disabled queries.
    puts backend
    puts node['pure-ftpd']
    puts node['pure-ftpd'][backend]
    puts node['pure-ftpd'][backend]['disabled_queries']


    node['pure-ftpd'][backend]['disabled_queries'].each do |query|
      node.default['pure-ftpd'][backend]['queries'][query] = nil
    end
    # Config file contains sensitive information, only root should have (read) access.
    template node['pure-ftpd']["#{backend}.conf"] do
      source "#{backend}.conf.erb"
      user "root"
      group "root"
      mode "0600"
    end
  end
end

# Creates virtual users' homes.
directory node['pure-ftpd']['virtual_users_root'] do
  owner  node['pure-ftpd']['user']
  group  node['pure-ftpd']['group']
  mode   "0775"
  action :create
end if node['pure-ftpd']['virtual_users_root']

# Enables and restarts Pure-FTPd service.
service ftp_service do
  supports :status => true, :restart => true
  action [:enable, :start]
end
