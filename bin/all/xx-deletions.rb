#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

xxtaxa = Taxon.search_by_prefix('xx')

pbar = ProgressBar.create(title: "XX-NAMES", total: xxtaxa.count, autofinish: false, format: '%t %b>> %i| %e')
candidate_deletions = Set.new

#CSV.open(output_dir(__FILE__) + "/xx-obj-deletions.csv", 'w') do |csv|
#  csv << ["ID Number", "xx speckey", "xx Scientific Name"]
  xxtaxa.each do |xxtaxon|
    pbar.increment
    similar = Taxon.find_by_scientific_name(xxtaxon.scientific_name[2..-1])
    similar_syn = TaxonVariation.find_by_scientific_name(xxtaxon.scientific_name[2..-1])
    next if similar.nil? && similar_syn.nil?
    if xxtaxon.catalogs.empty? && xxtaxon.children.empty?
      candidate_deletions << xxtaxon.speckey
      next
    end
  end
#end
pbar.finish

puts candidate_deletions.count