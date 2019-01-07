#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

sites = Site.where("location_accuracy LIKE '%Secondary%'")

sites.each do |site|
  #site.location_accuracy.gsub!("Primary", "primary")
  site.location_accuracy.gsub!("Secondary", "secondary")
  site.save
end