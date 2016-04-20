#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

pbar = ProgressBar.new("DATE-COLLECTED", Catalog.count)
count = 0

CSV.open(output_dir(__FILE__) + "/date-collected.csv", 'w') do |csv|
  csv << ["mkey", "date_collected"]
  Catalog.find_each do |item|
    count += 1
    pbar.set(count)
    d = Date.parse(item.date_collected) rescue nil
    if item.date_collected && ( d.nil? || d.year.nil? )
      csv << [item.mkey.to_i, item.date_collected]
    end
  end
end
pbar.finish