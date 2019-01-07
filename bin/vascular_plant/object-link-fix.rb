#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

obj = Catalog.find_by_catalog_number("CAN 592347")

obj.related_catalogs.each do |r|
  r.destroy
end