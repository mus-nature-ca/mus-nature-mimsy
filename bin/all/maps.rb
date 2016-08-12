#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

sm = SimpleMappr.new

dt = DateTime.now.strftime("%Y-%m-%d-%H-%M")
dir_maps = output_dir(__FILE__) + "/export/maps-#{dt}"
Dir.mkdir(dir_maps)

Taxon.find_each do |t|
  file_title = [t.id.to_s,t.scientific_name.gsub(" ", "_")].join("-")
  coords = t.catalogs.collect{ |c| c.coordinates.flatten }
                     .reject{ |c| c.empty? }
                     .uniq.map{ |c| c.join(",") }
                     .join("\n")
  if !coords.empty?
    sm.points = [coords]
    sm.color = ["255,0,0"]
    sm.download(File.join(dir_maps, file_title))
    puts file_title
  end
end