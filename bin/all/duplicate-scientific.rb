#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'

#Issue: https://trello.com/c/ZpAqA6HN

duplicates = Taxon.select("scientific_name, count(speckey)").group(:scientific_name).having("count(speckey) > 1")
pbar = ProgressBar.new("DUPLICATES", duplicates.length)
count = 0

CSV.open(File.dirname(__FILE__) + "/duplicate-scientific.csv", 'w') do |csv|
  csv << ["speckey", "scientific_name", "collection", "rank", "ancestors", "catalog_count"]
  duplicates.each do |t|
    count += 1
    pbar.set(count)
    Taxon.where(scientific_name: t[:scientific_name]).each do |dup|
      csv << [dup.speckey.to_i,
              dup.scientific_name,
              dup.collection,
              dup.rank,
              dup.ancestors.map{|a| a.scientific_name}.reverse.join(" | "),
              dup.catalogs.size]
    end
  end
end
pbar.finish