#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

log = "/Users/dshorthouse/Desktop/missing-media.csv"

CSV.open(log, 'w') do |csv|
  csv << ["MEDIA_ID", "LOCATOR"]
end

Parallel.map(Medium.all.in_groups_of(2000, false), progress: "Media", in_processes: 8) do |group|
  CSV.open("/Users/dshorthouse/Desktop/missing-media.csv", 'a') do |csv|
    group.each do |m|
      path = m.locator.gsub(/\\+/, '/').sub("n-nas1.mus-nature.ca","Volumes")
      if !File.exists?(File.join(path, m.media_id))
        puts m.media_id
        csv << [m.media_id, m.locator]
      end
    end
  end
end
