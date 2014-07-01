# Pure-FTPd cookbook

## Description

Chef cookbook for installing and configuring Pure-FTPd server.

## Requirements

### Platforms

* Debian, Ubuntu
* CentOS, Red Hat, Fedora, Scientific

### Cookbooks

* apt
* yum

## Attributes

See the `attributes/default.rb` for default values. Several attributes have values that vary based on the node's platform and version.

### Platform independent

* `node['pure-ftpd']['config_dir']` - location of configuration files (e.g. `/etc/pure-ftpd`).
* `node['pure-ftpd']['user']` - the user that Pure-FTPd will run as.
* `node['pure-ftpd']['group']` - the group that Pure-FTP will run as.
* `node['pure-ftpd']['home']` - home of the user.
* `node['pure-ftpd']['virtuals_users_root']` - location of virtual users' home directories.
* `node['pure-ftpd']['load_default_schema']` - loads default schema into the chosen backend.

### Platform dependent

* `node['pure-ftpd']['ldap.conf']` - location of the configuration file for the LDAP backend.
* `node['pure-ftpd']['mysql.conf']` - location of the configuration file for the MySQL backend.
* `node['pure-ftpd']['postgresql.conf']` - location of the configuration file for the PostgreSQL backend.
* `node['pure-ftpd']['puredb.conf']` - location of the PureDB file.

### Debian/Ubuntu specific

Debian and Ubuntu split the configuration file into multiple files named after the option keys and keep them in folders (auth, db, conf).

* `node['pure-ftpd']['auth_config_dir']` - location of the authentication configuration files.
* `node['pure-ftpd']['db_config_dir']` - location of the backends configurations files.
* `node['pure-ftpd']['conf_config_dir']` - location of Pure-FTPd parameters.

### Windows Specific

Windows isn't supported yet. Pure-FTPd requires Cygwin on Windows. See in the [documentation](http://download.pureftpd.org/pure-ftpd/doc/README.Windows).


### Authentication

If you choose MySQL or PostgreSQL as the backend you have to set the parameters for the database connection. A sample PostgreSQL configuration:

    {
      "pure-ftpd": {
        "postgresql": {
          "host": "localhost",
          "port": "5432",
          "database": "ftp_accounts",
          "user": "pure-ftpd",
          "password": "random_pw"
        }
      }
    }

You should provide queries for:

* getting user password (`get_pw`)
* getting uid (`get_uid`),
* getting gid (`get_gid`),
* getting home directory (`get_dir`),
* getting quota of files number (`get_quota_files`),
* getting quota of disk size (`get_quota_size`),
* getting upload ratio (`get_ul_ratio`),
* getting download ratio (`get_dl_ratio`),
* getting upload bandwidth (`get_ul_bandwidth`),
* getting download bandwidth (`get_dl_bandwidth`).

You can set custom queries and also disable any of them.

    {
      "postgresql": {
        "queries": {
          "get_pw": "SELECT Password FROM users WHERE User='\L'",
          "get_dir": "SELECT Dir FROM users WHERE User='\L'"
        },
        "disabled_queries": ["get_quota_files", "get_ul_ratio", "get_dl_ratio"]
      }
    }

If you want to use the same uid/gid for all users, you can set it with `default_uid` and `default_gid`.

    {
      "postgresql": {
        "default_uid": "502",
        "default_gid": "502"
      }
    }

You should set the password encryption method, default is `cleartext`, available methods are: `cleartext`, `crypt`, `md5` and `any`.

### Pure-FTPd options

Pure-FTPd has a lot of "yes/no" options. You can enable/disable them by adding the option key to the `enabled` or `disabled` array respectively.

    {
      "options": {
        "enabled": ["ChrootEveryone", "NoAnonymous"],
        "disabled": ["VerboseLog"]
      }
    }

* Enabled by default: `["ChrootEveryone", "Daemonize", "DisplayDotFiles", "DontResolve", "AntiWarez", "AnonymousCantUpload"]`
* Disabled by default: `["VerboseLog"]`
* If an option isn't in the `enabled` or `disabled` array then it will not be present in the configuration file(s).

Other options that require a value can be set directly in the `options` array.

    {
      "pure-ftpd": {
        "options" : {
          "MaxDiskUsage": "90",
          "MinUID": "1000"
        }
      }
    }

## Usage

To install Pure-FTPd use:

    { "run_list": ["recipe[pure-ftpd]"] }

To set backend:

    {
      "pure-ftpd": {
        "backend": "postgresql"
      }
    }

You have to select a valid backend. Available backends are: `ldap`, `mysql`, `postgresql`, `pam` and `unix`.

## Testing

Run [RuboCop](https://github.com/bbatsov/rubocop) or [Foodcritic](http://www.foodcritic.io/):

```bash
$ bundle exec foodcritic .
$ bundle exec rubocop
```

Run [ChefSpec](http://sethvargo.github.io/chefspec/):

```bash
$ bundle exec rspec
```

Run integration tests with [KitchenCI](http://kitchen.ci/) and [Serverspec](http://serverspec.org/):

```bash
$ bundle exec kitchen test
```

## License and Author

Author:: Gabor Nagy ([@Aigeruth](https://github.com/Aigeruth/))

Copyright:: 2013-2014 Gabor Nagy

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
