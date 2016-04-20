#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'

tax = Taxon.find(1146274)
tax.catalogs.each do |obj|
  speckeys = obj.taxa.map(&:speckey)
  if speckeys.include?(1008510)
    ct = CatalogTaxon.find_by_speckey(1146274)
    ct.delete
  end
end