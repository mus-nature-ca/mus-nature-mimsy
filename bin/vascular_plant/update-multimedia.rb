#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

media = Medium.where(format: "TIFF", created_by: "XGVIEWS").where("create_date LIKE '2019-02-06%'")

missing = []

media.each do |m|
  m.locator.gsub!("\\JPG\\", "\\TIF\\")
  m.save
  path = m.locator.gsub(/\\+/, '/').sub("n-nas1.mus-nature.ca","Volumes")
  if !File.exists?(File.join(path, m.media_id))
    missing << [m.media_id, "image missing"]
  end
end

byebug
puts ""