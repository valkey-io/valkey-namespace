#!/usr/bin/env ruby

require 'bundler/setup'
require 'valkey-namespace'

# Example of using dynamic namespaces with Proc
puts "=== Dynamic Namespace Example ==="
puts

# Simulate a multi-tenant application
class Tenant
  @current = nil

  class << self
    attr_accessor :current
  end
end

# Create a Valkey connection
valkey = Valkey.new(host: 'localhost', port: 6379)

# Create a namespaced client with dynamic namespace
namespaced = Valkey::Namespace.new(
  Proc.new { "tenant:#{Tenant.current}" },
  valkey: valkey
)

puts "Created dynamic namespace based on current tenant"
puts

# Tenant 1
Tenant.current = 'acme'
puts "Current tenant: #{Tenant.current}"
puts "Namespace: #{namespaced.namespace}"

namespaced.set('config:theme', 'blue')
namespaced.set('config:logo', 'acme-logo.png')

puts "Set config for tenant 'acme'"
puts "  theme: #{namespaced.get('config:theme')}"
puts "  logo: #{namespaced.get('config:logo')}"
puts

# Tenant 2
Tenant.current = 'widgets-inc'
puts "Current tenant: #{Tenant.current}"
puts "Namespace: #{namespaced.namespace}"

namespaced.set('config:theme', 'red')
namespaced.set('config:logo', 'widgets-logo.png')

puts "Set config for tenant 'widgets-inc'"
puts "  theme: #{namespaced.get('config:theme')}"
puts "  logo: #{namespaced.get('config:logo')}"
puts

# Switch back to Tenant 1
Tenant.current = 'acme'
puts "Switched back to tenant: #{Tenant.current}"
puts "  theme: #{namespaced.get('config:theme')}"
puts "  logo: #{namespaced.get('config:logo')}"
puts

# Verify isolation - check actual keys in Valkey
puts "Actual keys in Valkey:"
all_keys = valkey.keys('tenant:*')
all_keys.each do |key|
  puts "  #{key} => #{valkey.get(key)}"
end
puts

# Cleanup
puts "Cleaning up..."
Tenant.current = 'acme'
namespaced.clear
Tenant.current = 'widgets-inc'
namespaced.clear
puts "Done!"
