#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

other_numbers = CatalogOtherNumber.joins(:catalog)
                                  .where(type: "previous catalogue number")
                                  .where("catalogue.id_prefix": "CANM")

catalogs = []

other_numbers.each do |other_number|
  if !other_number.source.nil?
    if other_number.source.include?("Canadian Hepaticae") || other_number.source.include?("Canadian Liverworts")
      other_number.type = "exsiccat"
      other_number.save
    end
  end
end

byebug
puts ""


=begin
other_number_types = CatalogOtherNumber.pluck(:type).compact.uniq.sort

pbar = ProgressBar.create(title: "OtherNumbers", total: other_number_types.count, autofinish: false, format: '%t %b>> %i| %e')

CSV.open(output_dir(__FILE__) + "/other-numbers.csv", 'w') do |csv|
  csv << ["Type", "CatalogID"]
  other_number_types.each do |co|
    pbar.increment
    nums = CatalogOtherNumber.where(type: co)
    catalog = nil
    if nums.count == 1
      catalog = nums.first.catalog.catalog_number
    end
    csv << [co, catalog]
  end
end
pbar.finish
=end