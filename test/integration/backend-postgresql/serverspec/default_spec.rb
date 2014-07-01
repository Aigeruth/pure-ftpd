require 'spec_helper'
require 'pureftpd_helper'

describe 'PureFTPd' do
  include_examples 'PureFTPd', 'postgresql'
end
