#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

taxon = Taxon.find(1146377)

taxon.catalogs.each do |catalog|
  if catalog.catalog_taxa.pluck(:taxon_id).include?(1146377)
    catalog.catalog_taxa.where(speckey: 1146377).destroy_all
  end
end