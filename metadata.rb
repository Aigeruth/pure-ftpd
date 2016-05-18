name 'pure-ftpd'
maintainer 'Gabor Nagy'
maintainer_email 'mail@aigeruth.hu'
license 'Apache 2.0'
description 'Installs and configures Pure-FTPd server.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.2.0'
recipe 'pure-ftpd', 'Installs and configures Pure-FTPd server.'

source_url 'https://github.com/Aigeruth/pure-ftpd' if respond_to?(:source_url)
issues_url 'https://github.com/Aigeruth/pure-ftpd/issues' if respond_to?(:issues_url)

%w(debian ubuntu).each do |os|
  supports os
end

%w(redhat centos).each do |os|
  supports os, '>= 5.0'
end

depends 'apt', '~> 2.4'
depends 'yum-epel', '~> 0.3'
