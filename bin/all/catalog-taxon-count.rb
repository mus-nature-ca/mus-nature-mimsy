#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

ids = Taxon.find(ARGV[0]).self_and_descendants.map(&:id).uniq

count = 0
ids.in_groups_of(500, true).each do |group|
  count += CatalogTaxon.joins("INNER JOIN catalogue ON catalogue.mkey = items_taxonomy.mkey").where(taxon_id: group).where("catalogue.category1 = 'Amphibian and Reptile'").count
end

puts count