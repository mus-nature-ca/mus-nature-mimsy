#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'

#Issue: https://trello.com/c/JOeYqhyC

results = []
CSV.open(File.dirname(__FILE__) + "/xx-variations.csv", 'w') do |csv|
  csv << ["speckey", "scientific_name", "variation"]
  TaxonVariation.search_by_prefix("xx").each do |tv|
    if tv.taxon.collection == "Botany" && tv.scientific_name[2..-1] == tv.taxon.scientific_name
      csv << [tv.taxon.speckey.to_i, tv.taxon.scientific_name, tv.scientific_name]
    end
  end
end