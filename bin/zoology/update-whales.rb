#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/ABS_Sites.txt"

log = []

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|
  puts row["ID_NUMBER"].strip
  next if row["OLD_SITE_ID"].strip == row["NEW_SITE_ID"].strip

  old_site = Site.find_by_site_id(row["OLD_SITE_ID"])
  if old_site.catalogs.empty?
    log << row["OLD_SITE_ID"].strip
    old_site.destroy
  end
end

byebug
puts ""