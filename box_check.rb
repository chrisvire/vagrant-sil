#!/usr/bin/env ruby
require 'rubygems'
require 'rest_client'
require 'json'
require 'optparse'


$options = { :server => 'vagrantcloud.com', :username => 'chrisvire' }

def verbose(message)
  $stderr.puts message if $options[:verbose]
end

def debug(message)
  $stderr.puts "DEBUG: #{message}"
end

cmd_options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage box_check.rb [options]'
  opts.on('-v', '--[no-]verbose', 'Run verbosely') do |opt|
    cmd_options[:verbose] = opt
  end

  opts.on('-s', '--server SERVER', 'connect to SERVER') do |opt|
    cmd_options[:server] = opt
  end

  opts.on('-u', '--user USERNAME', 'check boxes for USERNAME') do |opt|
    cmd_options[:username] = opt
  end
end.parse!

$options.merge!(cmd_options)

server = $options[:server]
username = $options[:username]
verbose("Server:#{server}, Username: #{username}")

rest_url = "https://#{server}/api/v1"
verbose("Rest Url: #{rest_url}")

rest_api = RestClient::Resource.new(rest_url)

user_req = "/user/#{username}"
verbose("req: #{user_req} ...")
user_str = rest_api[user_req].get
verbose("res: #{user_str[0..40]}... (#{user_str.length})")

user = JSON.parse(user_str)
verbose("box count: #{user['boxes'].count}")
boxes = user['boxes']

boxes.each do |box|
  current_version = box['current_version']
  providers = current_version['providers']

  release_url = providers[0]['original_url']
  verbose("Box: #{box['name']}, Version: #{current_version['version']},\nUrl: #{release_url}")

  code = RestClient.head(release_url).code
  verbose("Code: #{code}\n")
  if code != 200
    $stderr.puts "WARNING: Missing file: box=#{box['name']}, version=#{current_version['version']}\nUrl=#{release_url}"
  end
end
