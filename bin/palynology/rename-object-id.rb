#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

catalogs = Catalog.where(id_prefix: "CMNPYF")

pbar = ProgressBar.new("ZERO-PAD", catalogs.count)
count = 0

catalogs.find_each do |catalog|
  new_id = catalog.id_number.gsub(/([A-Z]+)(\d+)/, '\1 \2').gsub(/([A-Z]+)\s0+(\d+)/, '\1 \2')
  if new_id != catalog.id_number
    catalog.id_number = new_id
    catalog.save
  end

  count += 1
  pbar.set(count)
end
pbar.finish