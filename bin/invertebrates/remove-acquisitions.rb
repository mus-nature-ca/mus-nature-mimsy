#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

acquisitions = [
"CMNI 2017-2298",
"CMNML 2017-4209"
]

acquisitions.each do |a|
  catalog = Catalog.find_by_catalog_number(a)
  ac = AcquisitionCatalog.find_by_catalog_number(a)
  if !ac.nil?
    byebug
    puts ""
  end
  if !ac.nil? && ac.m_id.nil?
    ac.destroy
  end
end