#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

numbers = CatalogOtherNumber.where("other_number LIKE '%/%'").where("on_type LIKE '%/%'").where("on_type LIKE '%jar%'")

numbers.each do |num|
  other_types = num.on_type.split("/").map(&:strip)
  other_numbers = num.other_number.gsub(/jar|vial/i, "").split("/").map(&:strip)
  other_types.each_with_index do |val, index|
    co = CatalogOtherNumber.new
    co.mkey = num.mkey
    co.other_number = other_numbers[index]
    co.on_type = val
    co.save
  end
  num.destroy
end