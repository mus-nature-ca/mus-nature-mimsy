#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../environment.rb'
include Sinatra::Mimsy::Helpers

ARGV << '-h' if ARGV.empty?

options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: unlock-user.rb [options]"

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end

  opts.on("-u", "--user [USERNAME]", String, "User to unlock") do |user|
    options[:user] = user
  end

end.parse!

if options[:user]
  connection = ActiveRecord::Base.connection
  connection.execute("ALTER USER %s ACCOUNT UNLOCK" % [options[:user].upcase])
  puts "#{options[:user]} unlocked"
end