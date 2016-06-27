#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'

xx_speckey = 502624
valid_speckey = 502983

tax = Taxon.find(xx_speckey)

tax.catalogs.each do |obj|
  speckeys = obj.taxa.map(&:speckey)
  ct = CatalogTaxon.where(speckey: xx_speckey, mkey: obj.mkey)
  if speckeys.include?(valid_speckey)
    ct.delete_all
  else
    ct_new = CatalogTaxon.new
    ct_new.speckey = valid_speckey
    ct_new.mkey = obj.mkey
    ct_new.save
    ct.delete_all
  end
end

tax.reload
if tax.catalogs.empty? && tax.children.empty?
  tax.variations.destroy_all
  tax.destroy
else
  puts "Taxon #{xx_speckey.to_s} not empty"
end