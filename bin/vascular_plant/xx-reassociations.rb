#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'

xx_speckey = 1146479
valid_speckey = 1009952

tax = Taxon.find(xx_speckey)
tax.catalogs.each do |obj|
  speckeys = obj.taxa.map(&:speckey)
  ct = CatalogTaxon.find_by_speckey(xx_speckey)
  if speckeys.include?(valid_speckey)
    ct.delete
  else
    ct_new = CatalogTaxon.new
    ct_new.speckey = valid_speckey
    ct_new.mkey = obj.mkey
    ct_new.save
    ct.delete
  end
end

tax = Taxon.find(xx_speckey)
if tax.catalogs.empty? && tax.children.empty?
  tax.destroy
else
  puts "Taxon #{xx_speckey.to_s} not empty"
end