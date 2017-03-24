#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

collectors = [
#  "Schofield, Wilfred",
#  "Brodo, Irwin",
#  "Schueler, Frederick",
#  "McAllister, Donald"
#  "Inuktaluk, Mina", 
"Cook, Francis"
]

collectors.each do |collector|
  lastname = collector.split(",")[0]
  media = Medium.joins(:catalogs).where("catalogue.collector LIKE '%#{collector}%'")
  media.each do |medium|
    file = File.join(medium.locator_linux, medium.media_id).gsub("n-nas1.mus-nature.ca", "Volumes")
    FileUtils.cp(file, File.join(output_dir(__FILE__), lastname, medium.media_id)) rescue nil
  end
end