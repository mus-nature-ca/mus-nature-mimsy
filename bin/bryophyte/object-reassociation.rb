#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

source_speckeys = [1083729, 1083728, 1083727, 1083726]
destination_speckey = 1199925

source_speckeys.each do |speckey|
  tax = Taxon.find(speckey)

  # move all the catalogs to destination
  tax.catalogs.each do |obj|
    cts = CatalogTaxon.where(speckey: speckey, mkey: obj.mkey)
    cts.each do |ct|
      #Look for CatalogName & make prior name or add a new one
      catalog_name = CatalogName.where(mkey: obj.mkey, item_name: ct.scientific_name, attributor: ct.attributor, attrib_date: ct.attrib_date)
      if catalog_name.empty?
        cn = CatalogName.new
        cn.mkey = obj.mkey
        cn.scientific_name = ct.scientific_name
        cn.attributor = ct.attributor
        cn.attrib_date = ct.attrib_date
        cn.prior_name = true
        cn.type = "previous name"
        cn.save
      else
        cn = catalog_name.first
        cn.prior_name = true
        cn.type = "previous name"
        cn.save
      end
    end
    #Now deal with the CatalogTaxon links
    cts.destroy_all

  end

  byebug

  # reassociate all variants
  tax.variations.each do |variant|
    variant.speckey = 1199925
    variant.save
  end

  # add name as variant
  tv = TaxonVariation.new
  tv.speckey = 1199925
  tv.variation = tax.scientific_name
  tv.authority = tax.source
  tv.save

  tax.reload
  if tax.catalogs.empty? && tax.children.empty?
    tax.destroy
  else
    puts "Taxon #{xx_speckey.to_s} not empty"
  end
end