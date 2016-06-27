#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

ct = CatalogTaxon.group(:mkey).having("count(mkey)> 1").count

Parallel.map(ct.to_a.in_groups_of(1_000, false), progress: "Associated", in_processes: 10) do |groups|
  CSV.open(output_dir(__FILE__) + "/objects-associated.csv", 'a') do |csv|
    groups.each do |mkeys|
      obj = Catalog.find(mkeys[0])
      next if !["Bryophyte", "Lichen"].include? obj.collection
      sci_names = obj.taxa.map(&:scientific_name).compact.uniq
      sci_names.delete_if{ |sci| sci[0..1].downcase ==  'xx' }
      next if sci_names.count <= 1
      csv << [obj.collection, obj.id_number, sci_names.count]
    end
  end
end