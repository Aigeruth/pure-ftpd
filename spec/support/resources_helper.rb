require 'spec_helper'

shared_examples 'resources' do |service|
  let(:user) { subject.node['pure-ftpd']['user'] }
  let(:group) { subject.node['pure-ftpd']['group'] }

  it { should create_group(user) }
  it { should create_user(group) }
  it { should install_package(service) }
  it { should enable_service(service) }
  it { should start_service(service) }
end
