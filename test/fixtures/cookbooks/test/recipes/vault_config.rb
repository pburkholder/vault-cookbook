vault_config '/home/vault/.vault.json' do |r|
  user 'vault'
  group 'vault'
  node['vault']['config'].each_pair { |k, v| r.send(k, v) }
end
