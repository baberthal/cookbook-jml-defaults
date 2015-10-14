require 'chefspec'
require 'chefspec/berkshelf'
require 'chef-vault/test_fixtures'
require 'json'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.include ChefVault::TestFixtures.rspec_shared_context, vault: true
  config.extend ChefSpec::Cacher
  config.fail_fast = true
  config.before(:each) do
    stub_data_bag_item('ssh', 'authorized_keys').and_return(
      JSON.parse(
        File.read(
          File.expand_path(
            'test/integration/data_bags/ssh/authorized_keys.json'
          )
        )
      )
    )
  end
end
