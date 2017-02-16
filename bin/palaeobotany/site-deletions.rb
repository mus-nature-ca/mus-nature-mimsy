#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

['977'..'999', '1001'..'1236'].flat_map(&:to_a).each do |num|
  site_id = "CMNPB #{num.rjust(5, "0")}"
  site = Site.find_by_site_id(site_id)
  if !site.nil? && site.catalogs.empty? && site.other_numbers.empty?
    site.destroy
  else
    puts site_id
  end
end