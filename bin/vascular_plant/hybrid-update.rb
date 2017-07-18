#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

Catalog.where("item_name LIKE '% X %'").find_each do |catalog|
  catalog.scientific_name.sub!(/\s+X\s+/, ' × ')
  catalog.save
  catalog.names.each do |name|
    if !name.scientific_name.nil?
      name.scientific_name.sub!(/\s+X\s+/, ' × ')
      name.save
    end
  end
end