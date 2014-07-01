shared_examples 'PureFTPd' do |backend|
  package_name = 'pure-ftpd'
  if %w(Debian Ubuntu).include?(os[:family]) && %w(mysql postgresql ldap).include?(backend)
    package_name << "-#{backend}"
  end

  describe yumrepo('epel'), if: %w(RedHat Fedora).include?(os[:family]) do
    it { should exist }
    it { should be_enabled }
  end

  describe package(package_name) do
    it { should be_installed }
  end

  describe service(package_name) do
    it { should be_enabled }
    it { should be_running }
  end

  describe process(package_name) do
    it { should be_running }
  end

  describe group('pureftp') do
    it { should exist }
  end

  describe user('pureftp') do
    it { should exist }
    it { should belong_to_group('pureftp') }
    it { should have_home_directory('/home/ftp') }
    it { should have_login_shell('/bin/false') }
  end

  describe port(21) do
    it { should be_listening.with('tcp') }
  end
end
