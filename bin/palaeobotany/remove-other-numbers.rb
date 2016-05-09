#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

catalogs = Catalog.where("id_number LIKE 'CMNFV%'")

pbar = ProgressBar.create(title: "OTHER-NUMS", total: catalogs.count, autofinish: false, format: '%t %b>> %i| %e')
catalogs.find_each do |catalog|
  others = catalog.other_numbers
  others.each do |other|
    if other.other_number.gsub(/([A-Z]+)\s+0+(...)$/, '\1 \2') == catalog.id_number && other.on_type == "entry number"
      other.delete
    end
  end
  pbar.increment
end
pbar.finish