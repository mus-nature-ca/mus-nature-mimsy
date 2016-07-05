#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

media = Medium.where.not(locator: nil)

pbar = ProgressBar.create(title: "MediaPaths", total: media.count, autofinish: false, format: '%t %b>> %i| %e')
media.find_each do |m|
  pbar.increment
  if m.locator[0].downcase == "m"
    m.locator.sub! 'm:\mimsy', '\\n-fs1.mus-nature.ca\dept\MIMSY'
    m.locator.sub! 'M:\MIMSY', '\\n-fs1.mus-nature.ca\dept\MIMSY'
    m.save
  end
end
pbar.finish


=begin
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
=end