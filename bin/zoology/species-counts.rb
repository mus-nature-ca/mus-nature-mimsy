#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

taxon = Taxon.where(scientific_name: "Reptilia").first
descendants = taxon.descendants.map{|t| t if ["species", "subspecies"].include?(t.rank)}.compact

CSV.open(output_dir(__FILE__) + "/taxon-list.csv", 'w') do |csv|
  descendants.each do |d|
    collections = d.catalogs.collect(&:collection).compact.uniq.join(",")
    csv << [d.scientific_name, d.id, d.parent_id, collections]
  end
end
