#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

numbers = CatalogOtherNumber.where(other_number: "Original Sample number")

numbers.find_each do |num|
  on_type = num.on_type.dup
  num.on_type = num.other_number.dup
  num.other_number = on_type
  num.save
end