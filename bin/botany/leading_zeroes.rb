#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

objs = Catalog.where(collection: Collection::BOTANY).pluck(:catalog_number)

objs.each do |obj|
  parts = obj.match(/^([A-Z]{3,})\s+?(.*)/)
  leading_zeroes = parts[2].match(/^0{1,}/)
  if leading_zeroes
    (1..leading_zeroes.to_s.size).each do |num|
      new_obj = [parts[1], parts[2].strip.gsub(/^0{#{num}}/,"")].join(" ")
      if obj != new_obj && !Catalog.find_by_catalog_number(new_obj).nil?
        puts [obj, new_obj].join(" vs ")
      end
    end
  end
end