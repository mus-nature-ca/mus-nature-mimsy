#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

pbar = ProgressBar.create(title: "Date Collected", total: Catalog.count, autofinish: false, format: '%t %b>> %i| %e')

CSV.open(output_dir(__FILE__) + "/date-collected.csv", 'w') do |csv|
  csv << ["mkey", "date_collected"]
  Catalog.find_each do |item|
    pbar.increment
    d = Date.parse(item.date_collected) rescue nil
    if item.date_collected && ( d.nil? || d.year.nil? )
      csv << [item.mkey.to_i, item.date_collected]
    end
  end
end
pbar.finish