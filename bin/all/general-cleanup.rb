#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = File.join(__dir__, '../../', 'db', 'tables.txt')

CSV.foreach(file) do |row|
  table = row.first
  sql = "SELECT COUNT(*) as total FROM #{table}"
  begin
    records = ActiveRecord::Base.connection.exec_query(sql)
    total = records.entries.first["total"]
    if total == 0
      puts "#{table}".yellow
    else
      puts "#{table} (#{total})".green
    end
  rescue ActiveRecord::StatementInvalid
    puts "#{table}".red
  end
end