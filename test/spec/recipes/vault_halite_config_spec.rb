require 'halite/spec_helper'
require 'poise'

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
        { 'certificate' => 'foo', 'private_key' => 'bar' }
      )
    end

    recipe do
      vault_config '/home/vault/.vault.json' do |r|
        user 'vault'
        group 'vault'
        tls_key_file '/etc/vault/ssl/private/vault.key'
        tls_cert_file '/etc/vault/ssl/certs/vault.crt'
        tls_disable ''
      end
    end

      it { is_expected.to create_directory('/etc/vault/ssl/certs') }
      it { is_expected.to create_directory('/etc/vault/ssl/private') }

      it do
        is_expected.to create_file('/home/vault/.vault.json')
        .with(owner: 'vault')
        .with(group: 'vault')
        .with(mode: '0640')
      end

      it do
        is_expected.to create_file('/etc/vault/ssl/certs/vault.crt')
        .with(content: 'foo')
        .with(owner: 'vault')
        .with(group: 'vault')
        .with(mode: '0644')
      end

      it do
        is_expected.to create_file('/etc/vault/ssl/private/vault.key')
        .with(content: 'bar')
        .with(sensitive: true)
        .with(owner: 'vault')
        .with(group: 'vault')
        .with(mode: '0640')
      end
  end
end
