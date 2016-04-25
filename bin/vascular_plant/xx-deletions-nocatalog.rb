#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

collection = "Botany"
xxtaxa = Taxon.search_by_prefix('xx')

pbar = ProgressBar.new("XX-NAMES", xxtaxa.count)
count = 0

CSV.open(output_dir(__FILE__) + "/xx-taxa-deletions-nocatalog.csv", 'w') do |csv|
  csv << ["speckey", "Scientific Name", "Author/Date", "Parent", "Level Name"]
  xxtaxa.each do |xx|
    count += 1
    pbar.set(count)

    next if xx.collection != "Botany"
    next if !xx.leaf?
    next if !xx.catalogs.empty?
    similar = Taxon.find_by_scientific_name(xx.scientific_name[2..-1])
    next if !similar
    next if similar && xx.authority != similar.authority

    parent_id = (xx.parent) ? xx.parent.id : nil
    csv << [xx.id, xx.scientific_name, xx.authority, parent_id, xx.rank]
    #xx.destroy
  end
end
pbar.finish