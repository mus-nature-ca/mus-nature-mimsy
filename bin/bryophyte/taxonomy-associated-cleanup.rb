#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

ct = CatalogTaxon.where(type_status: "associated species")

CSV.open(output_dir(__FILE__) + "/taxonomy-associated-cleanup.csv", 'a') do |csv|
  csv << CatalogName.attribute_names
  ct.each do |tax|
    cn = CatalogName.where(catalog_id: tax.catalog_id)
               .where("tna_type LIKE '%associated species%'")
               .where(scientific_name: tax.scientific_name)
    if cn.count > 0
      cn.each do |name|
        csv << name.attributes.values
        name.destroy
      end
    end
  end
end