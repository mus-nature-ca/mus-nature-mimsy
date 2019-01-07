#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

start_date = '2018-04-01'
end_date = '2018-06-30'

counts = Catalog.group(:category1).where("create_date >= '#{start_date}'").where("create_date <= '#{end_date}'").count
total = counts.values.inject(:+)

puts counts.sort.to_h
puts "Total Digitized: #{total}"