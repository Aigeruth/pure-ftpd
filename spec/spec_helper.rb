require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.log_level = :error
  config.platform = 'ubuntu'
  config.version = '12.04'
end

DEB_PLATFORMS = {
  'ubuntu' => %w(12.04 14.04),
  'debian' => %w(6.0.5 7.5)
}
RPM_PLATFORMS = {
  'centos' => %w(5.10 6.5),
  'redhat' => %w(5.10 6.5),
  'fedora' => %w(20)
}

def service_name(platform, backend)
  'pure-ftpd' + (DEB_PLATFORMS.keys.include?(platform) && %w(mysql postgresql ldap).include?(backend) ? "-#{backend}" : '')
end

at_exit { ChefSpec::Coverage.report! }
