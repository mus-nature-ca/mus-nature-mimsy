#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

ct = CatalogTitle.pluck(:title).compact.uniq.sort

CSV.open(output_dir(__FILE__) + "/catalog-title.csv", 'w') do |csv|
  ct.each do |cat|
    csv << [cat]
  end
end