#!/usr/bin/env ruby

require 'bundler/setup'
require 'valkey-namespace'

# Basic usage example
puts "=== Basic Valkey::Namespace Usage ==="
puts

# Create a Valkey connection
valkey = Valkey.new(host: 'localhost', port: 6379)
puts "Connected to Valkey"

# Create a namespaced client
namespaced = Valkey::Namespace.new(:myapp, valkey: valkey)
puts "Created namespace: myapp"
puts

# Set and get values
puts "Setting 'user:1' to 'John Doe'"
namespaced.set('user:1', 'John Doe')

puts "Getting 'user:1': #{namespaced.get('user:1')}"
puts

# The actual key in Valkey is namespaced
puts "Actual key in Valkey: 'myapp:user:1'"
puts "Direct get from Valkey: #{valkey.get('myapp:user:1')}"
puts

# Multiple keys
puts "Setting multiple users..."
namespaced.mset('user:2', 'Jane Smith', 'user:3', 'Bob Johnson')

puts "Getting all user keys:"
keys = namespaced.keys('user:*')
keys.each do |key|
  puts "  #{key} => #{namespaced.get(key)}"
end
puts

# Hash operations
puts "Setting hash fields..."
namespaced.hset('user:1:profile', 'email', 'john@example.com')
namespaced.hset('user:1:profile', 'age', '30')

puts "Getting hash:"
profile = namespaced.hgetall('user:1:profile')
puts "  #{profile.inspect}"
puts

# List operations
puts "Adding to list..."
namespaced.rpush('notifications', 'Welcome!')
namespaced.rpush('notifications', 'New message')

puts "List contents:"
notifications = namespaced.lrange('notifications', 0, -1)
notifications.each_with_index do |msg, i|
  puts "  #{i + 1}. #{msg}"
end
puts

# Cleanup
puts "Cleaning up namespace..."
namespaced.clear
puts "Done!"
