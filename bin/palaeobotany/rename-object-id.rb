#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

catalogs = Catalog.where(id_prefix: "CMNPB")
pbar = ProgressBar.create(title: "ZERO-PAD", total: catalogs.count, autofinish: false, format: '%t %b>> %i| %e')

catalogs.find_each do |catalog|
  new_id = catalog.id_number.gsub(/([A-Z]+)\s+0+(\d+)/, '\1 \2')
  if new_id != catalog.id_number
    catalog.id_number = new_id
    catalog.save
  end
  pbar.increment
end
pbar.finish