#
# Cookbook Name:: pure-ftpd
# Attributes:: pure-ftpd
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

default['pure-ftpd']['backend']                          = nil
default['pure-ftpd']['load_default_schema']              = "no"
default['pure-ftpd']['user']                             = "pureftp"
default['pure-ftpd']['group']                            = "pureftp"
default['pure-ftpd']['home']                             = "/home/ftp"
default['pure-ftpd']['virtual_users_root']               = nil

case node['platform']
when "debian", "ubuntu"
  default['pure-ftpd']['config_dir']                     = "/etc/pure-ftpd"
  default['pure-ftpd']['conf_config_dir']                = "/etc/pure-ftpd/conf"
  default['pure-ftpd']['auth_config_dir']                = "/etc/pure-ftpd/auth"
  default['pure-ftpd']['db_config_dir']                  = "/etc/pure-ftpd/db"
  default['pure-ftpd']['ldap.conf']                      = "#{default['pure-ftpd']['db_config_dir']}/ldap.conf"
  default['pure-ftpd']['mysql.conf']                     = "#{default['pure-ftpd']['db_config_dir']}/mysql.conf"
  default['pure-ftpd']['postgresql.conf']                = "#{default['pure-ftpd']['db_config_dir']}/postgresql.conf"
  default['pure-ftpd']['puredb.conf']                    = "#{default['pure-ftpd']['config_dir']}/pureftpd.pdb"
when "redhat", "centos", "scientific", "fedora", "amazon", "oracle"
  default['pure-ftpd']['config_dir']                     = "/etc/pure-ftpd"
  default['pure-ftpd']['conf_config_dir']                = "/etc/pure-ftpd"
  default['pure-ftpd']['auth_config_dir']                = "/etc/pure-ftpd"
  default['pure-ftpd']['db_config_dir']                  = "/etc/pure-ftpd"
  default['pure-ftpd']['ldap.conf']                      = "#{default['pure-ftpd']['db_config_dir']}/pureftpd-ldap.conf"
  default['pure-ftpd']['mysql.conf']                     = "#{default['pure-ftpd']['db_config_dir']}/pureftpd-mysql.conf"
  default['pure-ftpd']['postgresql.conf']                = "#{default['pure-ftpd']['db_config_dir']}/pureftpd-pgsql.conf"
  default['pure-ftpd']['puredb.conf']                    = "#{default['pure-ftpd']['config_dir']}/pureftpd.pdb"
else
  default['pure-ftpd']['config_dir']                     = "/etc/pure-ftpd"
  default['pure-ftpd']['conf_config_dir']                = "/etc/pure-ftpd"
  default['pure-ftpd']['auth_config_dir']                = "/etc/pure-ftpd"
  default['pure-ftpd']['db_config_dir']                  = "/etc/pure-ftpd"
end

default['pure-ftpd']['auth']['ldap']['enabled']          = "no"
default['pure-ftpd']['auth']['mysql']['enabled']         = "no"
default['pure-ftpd']['auth']['pam']['enabled']           = "no"
default['pure-ftpd']['auth']['postgresql']['enabled']    = "no"
default['pure-ftpd']['auth']['puredb']['enabled']        = "no"
default['pure-ftpd']['auth']['unix']['enabled']          = "no"
case node['platform']
when "debian", "ubuntu"
  default['pure-ftpd']['auth']['ldap']['priority']       = "10"
  default['pure-ftpd']['auth']['ldap']['filename']       = "LDAPConfigFile"
  default['pure-ftpd']['auth']['ldap']['auth_name']      = "ldap"
  default['pure-ftpd']['auth']['mysql']['priority']      = "30"
  default['pure-ftpd']['auth']['mysql']['filename']      = "MySQLConfigFile"
  default['pure-ftpd']['auth']['mysql']['auth_name']     = "mysql"
  default['pure-ftpd']['auth']['pam']['priority']        = "70"
  default['pure-ftpd']['auth']['pam']['filename']        = "PAMAuthentication"
  default['pure-ftpd']['auth']['pam']['auth_name']       = "pam"
  default['pure-ftpd']['auth']['postgresql']['priority'] = "30"
  default['pure-ftpd']['auth']['postgresql']['filename'] = "PGSQLConfigFile"
  default['pure-ftpd']['auth']['postgresql']['auth_name']= "pgsql"
  default['pure-ftpd']['auth']['puredb']['priority']     = "60"
  default['pure-ftpd']['auth']['puredb']['filename']     = "PureDB"
  default['pure-ftpd']['auth']['puredb']['auth_name']    = "puredb"
  default['pure-ftpd']['auth']['unix']['filename']       = "UnixAuthentication"
  default['pure-ftpd']['auth']['unix']['priority']       = "65"
  default['pure-ftpd']['auth']['unix']['auth_name']      = "unix"
end

# Documentation: http://download.pureftpd.org/pub/pure-ftpd/doc/README
default['pure-ftpd']['options']['enabled']               = ["ChrootEveryone", "Daemonize", "DisplayDotFiles", "DontResolve", "AntiWarez", "AnonymousCantUpload"]
default['pure-ftpd']['options']['disabled']              = ['VerboseLog']
default['pure-ftpd']['options']['AnonymousBandwidth']    = nil
default['pure-ftpd']['options']['AnonymousRatio']        = nil
default['pure-ftpd']['options']['AltLog']                = "clf:/var/log/pure-ftpd/transfer.log"
default['pure-ftpd']['options']['Bind']                  = nil
default['pure-ftpd']['options']['Bonjour']               = nil
default['pure-ftpd']['options']['ClientCharset']         = nil
default['pure-ftpd']['options']['FSCharset']             = "UTF-8"
default['pure-ftpd']['options']['ForcePassiveIP']        = nil
default['pure-ftpd']['options']['FortunesFile']          = nil
default['pure-ftpd']['options']['LimitRecursion']        = nil
default['pure-ftpd']['options']['LogPid']                = nil
default['pure-ftpd']['options']['Login']                 = nil
default['pure-ftpd']['options']['MaxDiskUsage']          = "90"
default['pure-ftpd']['options']['MaxDiskUsage_pct']      = nil
default['pure-ftpd']['options']['MaxClientsNumber']      = nil
default['pure-ftpd']['options']['MaxClientsPerIP']       = nil
default['pure-ftpd']['options']['MaxIdleTime']           = nil
default['pure-ftpd']['options']['MaxLoad']               = nil
default['pure-ftpd']['options']['MinUID']                = nil
default['pure-ftpd']['options']['PassivePortRange']      = nil
default['pure-ftpd']['options']['PIDFile']               = nil
default['pure-ftpd']['options']['PerUserLimits']         = nil
default['pure-ftpd']['options']['PureDB']                = nil
default['pure-ftpd']['options']['Quota']                 = nil
default['pure-ftpd']['options']['Umask']                 = nil
default['pure-ftpd']['options']['UserBandwidth']         = nil
default['pure-ftpd']['options']['UserRatio']             = nil
default['pure-ftpd']['options']['SyslogFacility']        = nil
default['pure-ftpd']['options']['TLS']                   = nil # <0:no TLS | 1:TLS+cleartext | 2:enforce TLS | 3: enforce encrypted data channel as well>
default['pure-ftpd']['options']['TLSCipherSuite']        = nil
default['pure-ftpd']['options']["TrustedGID" ]           = nil
default['pure-ftpd']['options']['TrustedIP']             = nil

# Default settings for LDAP backend.
default['pure-ftpd']['ldap']['bind_dn']                           = nil
default['pure-ftpd']['ldap']['password']                          = nil
default['pure-ftpd']['ldap']['base_db']                           = nil
default['pure-ftpd']['ldap']['host']                              = "localhost"
default['pure-ftpd']['ldap']['port']                              = "389"
default['pure-ftpd']['ldap']['password_encryption']               = "cleartext"
default['pure-ftpd']['ldap']['version']                           = nil
default['pure-ftpd']['ldap']['default_uid']                       = nil
default['pure-ftpd']['ldap']['default_gid']                       = nil
default['pure-ftpd']['ldap']['filter']                            = "(&(objectClass=posixAccount)(uid=\L))"
default['pure-ftpd']['ldap']['home']                              = "homeDirectory"
default['pure-ftpd']['ldap']['auth_method']                       = "PASSWORD"
default['pure-ftpd']['ldap']['tls']                               = nil

# Default settings for MySQL backend.
default['pure-ftpd']['mysql']['user']                             = nil
default['pure-ftpd']['mysql']['password']                         = nil
default['pure-ftpd']['mysql']['database']                         = "users"
default['pure-ftpd']['mysql']['host']                             = "localhost"
default['pure-ftpd']['mysql']['port']                             = "3306"
default['pure-ftpd']['mysql']['password_encryption']              = "cleartext"
default['pure-ftpd']['mysql']['default_uid']                      = nil
default['pure-ftpd']['mysql']['default_gid']                      = nil
default['pure-ftpd']['mysql']['disabled_queries']                 = []
default['pure-ftpd']['mysql']['queries']['get_pw']                = "SELECT Password FROM users WHERE User='\L'"
default['pure-ftpd']['mysql']['queries']['get_uid']               = nil
default['pure-ftpd']['mysql']['queries']['get_gid']               = nil
default['pure-ftpd']['mysql']['queries']['get_dir']               = "SELECT Dir FROM users WHERE User='\L'"
default['pure-ftpd']['mysql']['queries']['get_quota_size']        = nil
default['pure-ftpd']['mysql']['queries']['get_quota_files']       = nil
default['pure-ftpd']['mysql']['queries']['get_ul_ratio']          = nil
default['pure-ftpd']['mysql']['queries']['get_dl_ratio']          = nil
default['pure-ftpd']['mysql']['queries']['get_ul_bandwidth']      = nil
default['pure-ftpd']['mysql']['queries']['get_dl_bandwidth']      = nil

# Default settings for PostgreSQL backend.
default['pure-ftpd']['postgresql']['host']                        = "localhost"
default['pure-ftpd']['postgresql']['port']                        = "5432"
default['pure-ftpd']['postgresql']['database']                    = "users"
default['pure-ftpd']['postgresql']['user']                        = nil
default['pure-ftpd']['postgresql']['password']                    = nil
default['pure-ftpd']['postgresql']['password_encryption']         = "cleartext"
default['pure-ftpd']['postgresql']['default_uid']                 = nil
default['pure-ftpd']['postgresql']['default_gid']                 = nil
default['pure-ftpd']['postgresql']['disabled_queries']            = []
default['pure-ftpd']['postgresql']['queries']['get_pw']           = "SELECT Password FROM users WHERE User='\L'"
default['pure-ftpd']['postgresql']['queries']['get_uid']          = nil
default['pure-ftpd']['postgresql']['queries']['get_gid']          = nil
default['pure-ftpd']['postgresql']['queries']['get_dir']          = "SELECT Dir FROM users WHERE User='\L'"
default['pure-ftpd']['postgresql']['queries']['get_quota_size']   = nil
default['pure-ftpd']['postgresql']['queries']['get_quota_files']  = nil
default['pure-ftpd']['postgresql']['queries']['get_ul_ratio']     = nil
default['pure-ftpd']['postgresql']['queries']['get_dl_ratio']     = nil
default['pure-ftpd']['postgresql']['queries']['get_ul_bandwidth'] = nil
default['pure-ftpd']['postgresql']['queries']['get_dl_bandwidth'] = nil
