#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

attributors = Set.new
missing = Set.new

pbar = ProgressBar.create(title: "GatheringCatalogNameAttributors", total: CatalogName.count, autofinish: false, format: '%t %b>> %i| %e')
CatalogName.pluck(:attributor).compact.uniq do |cn|
  pbar.increment
  cn.split("; ").each do |attributor|
    attributors.add attributor
  end
end
pbar.finish

pbar = ProgressBar.create(title: "GatheringCatalogTaxonAttributors", total: CatalogTaxon.count, autofinish: false, format: '%t %b>> %i| %e')
CatalogTaxon.pluck(:attributor).compact.uniq do |ct|
  pbar.increment
  ct.split("; ").each do |attributor|
    attributors.add attributor
  end
end
pbar.finish

pbar = ProgressBar.create(title: "GatheringCatalogCollectorAttributors", total: CatalogCollector.count, autofinish: false, format: '%t %b>> %i| %e')
CatalogCollector.pluck(:attributor).compact.uniq do |cc|
  pbar.increment
  cc.split("; ").each do |attributor|
    attributors.add attributor
  end
end
pbar.finish

attributors.to_a.in_groups_of(10, false) do |batch|
  batch.each do |attributor|
    next if !Person.find_by_preferred_name(attributor).nil?
    next if !PersonVariation.find_by_variation(attributor).nil?
    missing.add attributor
  end
end

CSV.open(output_dir(__FILE__) + "/missing-agents.csv", 'w') do |csv|
  missing.each do |agent|
    csv << [agent]
  end
end