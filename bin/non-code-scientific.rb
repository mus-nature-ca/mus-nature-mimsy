#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../environment.rb'

#Issue: https://trello.com/c/ZpAqA6HN

parser = ScientificNameParser.new
pbar = ProgressBar.new("COMPLIANT", Taxon.count)
CSV.open(File.dirname(__FILE__) + "/non-code-scientific.csv", 'w') do |csv|
  csv << ["speckey", "scientific_name"]
  Taxon.pluck("speckey","scientific_name").each_with_index do |t,i|
    pbar.set(i)
    if !parser.parse(t[1])[:scientificName][:parsed]
      csv << [t[0].to_i,t[1]]
    end
  end
end
pbar.finish