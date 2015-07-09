require 'halite/spec_helper'
require 'chefspec/berkshelf'
require 'poise'
#require 'chef-vault'


RSpec.configure do |config|
  config.include Halite::SpecHelper
end

require_relative '../../../libraries/vault_config'


describe Chef::Resource::VaultConfig do
  step_into(:vault_config)

  context 'with an explicit user and group name' do
    before :each do
      allow_any_instance_of(Object).to receive(:include_recipe).and_return(true)
      allow_any_instance_of(Object).to receive(:chef_vault_item).and_return(
        { "certificate" => "foo", "private_key" => "bar"}
      )
    end

    recipe do
      vault_config '/home/vault/.vault.json' do |r|
        user 'vault'
        group 'vault'
        tls_key_file '/etc/foo'
        tls_cert_file '/some/path/bar'
        tls_disable 'true'
      end
    end

    it do
      is_expected.to create_file('/home/vault/.vault.json')
    end
  end
end
