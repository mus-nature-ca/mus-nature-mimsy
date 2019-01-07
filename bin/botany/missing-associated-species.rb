#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

catalog_counts = CatalogTaxon.group(:mkey).count

catalog_counts.each do |pr|
  next if pr[1] < 2
  ct = CatalogTaxon.where(mkey: pr[0]).pluck(:affiliation, :speckey)
  collection = Taxon.find(ct.first[1]).collection
  next if collection != "Botany"
  if pr[1] != ct.map{|a| a[0]}.compact.count + 1
    gm = GroupMember.new
    gm.table_key = pr[0]
    gm.group_id = 4751
    gm.save
  end
end