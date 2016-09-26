#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

#placekeys = [17918, 17919, 10763, 29175, 23391]

#CSV.open(output_dir(__FILE__) + "/mingan_data.csv", 'w') do |csv|
#  csv << Catalog.custom_attribute_names
#  CatalogCollectionPlace.where(place_id: placekeys).find_each do |row|
#    csv << Catalog.find(row.catalog_id).custom_attributes.values
#  end
#end

matches = %r{
  \d{5,}
}x

objs = CollectedDate.where.not(date_text: nil)

pbar = ProgressBar.create(title: "Date Collected", total: objs.size, autofinish: false, format: '%t %b>> %i| %e')

all_matches = []

objs.find_each do |obj|
  pbar.increment
  matched = matches.match(obj.date_text)
  if matched
    all_matches << [obj.date_text, obj.catalog.catalog_number]
  end
end

byebug
puts ""

pbar.finish