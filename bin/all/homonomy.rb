#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'

#Issue: https://trello.com/c/ZpAqA6HN

count = 0
#Everything under genus
pbar = ProgressBar.new("HOMONYMY", Taxon.count)

CSV.open(File.dirname(__FILE__) + "/homonymy.csv", 'w') do |csv|
  csv << ["speckey", "scientific_name"]
  Taxon.find_each do |t|
    count += 1
    pbar.set(count)
    if t.collection != t.root.collection
      csv << [t.speckey.to_i, t.scientific_name]
    end rescue nil
  end
end
pbar.finish