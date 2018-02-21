#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

objects = [
"CMNC 2017-3853",
"CMNI 2017-2288",
"CMNML 2017-3911",
"CMNA 2017-8825",
"CMNML 2017-3912",
"CMNI 2017-2290",
"CMNI 2017-2291",
"CMNI 2017-2294",
"CMNI 2017-2296",
"CMNI 2017-2297",
"CMNA 2017-3747",
"CMNA 2017-3749"
]

objects.each do |o|
  puts o if !Catalog.find_by_catalog_number(o).nil?
end