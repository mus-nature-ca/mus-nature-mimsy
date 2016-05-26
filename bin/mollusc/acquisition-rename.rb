#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

acq = Acquisition.find_by_acquisition_number("A2015.0028")

acq.acquisition_catalogs.each do |ac|
  cat_num = Catalog.find(ac.catalog_id).catalog_number
  ac.id_number = cat_num
  ac.save
end