#!/usr/bin/env ruby
# encoding: utf-8
ENV['RACK_ENV'] = "production"
require_relative '../environment.rb'
include Sinatra::Mimsy::Helpers

ARGV << '-h' if ARGV.empty?

options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: sessions.rb [options]"

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end

  opts.on("-l", "--list", "List all sessions") do
    options[:list] = true
  end

  opts.on("-k", "--kill [USERNAME]", String, "Username whose session to kill") do |user|
    options[:user] = user
  end

end.parse!

if options[:list]
  connection = ActiveRecord::Base.connection
  results = connection.select_all("SELECT status, sid || ',' || serial#, last_call_et/60 as idle_time, program, machine, username FROM v$session WHERE username IS NOT NULL")
  results.each do |result|
    puts [result["username"], result["status"], result["idle_time"], result["program"], result["machine"]].join(", ")
  end
end

if options[:user]
  connection = ActiveRecord::Base.connection
  result = connection.select_one("SELECT sid || ',' || serial# as session_id FROM v$session WHERE username = '%s' AND status = 'INACTIVE'" % [options[:user].upcase])
  if !result.nil?
    connection.execute("ALTER SYSTEM KILL SESSION '%s'" % [result["session_id"]])
    puts "Session killed for #{options[:user]}. It may take 15-20min to take effect."
  else
    puts "Session #{options[:user]} is not INACTIVE"
  end
end