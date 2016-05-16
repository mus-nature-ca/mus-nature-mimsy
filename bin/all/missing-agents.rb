#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

attributors = Set.new
missing = Set.new

pbar = ProgressBar.create(title: "MissingName", total: CatalogTaxon.count, autofinish: false, format: '%t %b>> %i| %e')
CatalogTaxon.find_each do |cn|
  pbar.increment
  next if cn.attributor.nil?
  attributor = cn.attributor.squish
  if cn.attributor != attributor
    cn.attributor = attributor
    cn.save
  end
end
=begin
CatalogName.pluck(:attributor).compact.uniq do |cn|
  pbar.increment
  cn.split("; ").each do |attributor|
    attributors.add attributor
  end
end
=end
pbar.finish

=begin
pbar = ProgressBar.create(title: "MissingTaxa", total: CatalogTaxon.count, autofinish: false, format: '%t %b>> %i| %e')
CatalogTaxon.pluck(:attributor).compact.uniq do |ct|
  pbar.increment
  ct.split("; ").each do |attributor|
    attributors.add attributor
  end
end
pbar.finish

pbar = ProgressBar.create(title: "MissingCollector", total: CatalogCollector.count, autofinish: false, format: '%t %b>> %i| %e')
CatalogCollector.pluck(:attributor).compact.uniq do |cc|
  pbar.increment
  cc.split("; ").each do |attributor|
    attributors.add attributor
  end
end
pbar.finish

pbar = ProgressBar.create(title: "MissingPerson", total: attributors.size, autofinish: false, format: '%t %b>> %i| %e')
attributors.each do |attributor|
  pbar.increment
  next if !Person.find_by_preferred_name(attributor).nil?
  next if !PersonVariation.find_by_variation(attributor).nil?
  missing.add attributor
end
pbar.finish

puts missing.to_a
puts missing.size
=end