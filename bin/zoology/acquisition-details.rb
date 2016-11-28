#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

items = Catalog.where("id_number LIKE 'CMNMA%'").where(credit_line: "1973-233")

CSV.open(output_dir(__FILE__) + "/acquisition-details.csv", 'w') do |csv|
  csv << ["id_number", "other_number", "on_type", "taxonomy"]
  items.each do |item|
    other_number = item.other_numbers.map(&:other_number).join(" | ")
    on_type = item.other_numbers.map(&:on_type).join(" | ")
    taxonomy = item.catalog_taxa.map(&:scientific_name).join(" | ")
    csv << [item.id_number, other_number, on_type, taxonomy]
  end
end

