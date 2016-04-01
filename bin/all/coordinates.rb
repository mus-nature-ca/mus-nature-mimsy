#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'

#Issue: https://trello.com/c/ZpAqA6HN

pbar = ProgressBar.new("COORDINATES", Site.count)
count = 0

CSV.open(File.dirname(__FILE__) + "/coordinates.csv", 'w') do |csv|
  csv << ["skey", "site_id", "start_latitude_dec", "start_longitude_dec"]
  Site.find_each do |item|
    count += 1
    pbar.set(count)
    lat = item.start_latitude_dec.to_f
    lng = item.start_longitude_dec.to_f
    if lat > 90 || lat < -90 || lng > 180 || lng < -180
      csv << [item.skey, item.site_id, lat, lng]
    end
  end
end
pbar.finish