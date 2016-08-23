#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

collections = ["Alga", "Bryophyte", "Lichen", "Vascular Plant"]
#sites = Site.joins(:catalogs).where("catalogue.category1": collections).where.not(location_accuracy: nil)

sites = Site.where.not(location_accuracy: nil)

bits = []

pbar = ProgressBar.create(title: "SITES", total: sites.count, autofinish: false, format: '%t %b>> %i| %e')

sites.find_each do |site|
  pbar.increment

  #skip if other fields contain values
  #next if !site.coord_uncertainty.nil?
  #next if !site.uncertainty_unit.nil?

  matched = /([<>])?(\d{1,})(\s+)?([a-z]{2})/.match(site.location_accuracy)
  if matched
    site.coord_uncertainty_verb = matched[0].squeeze(" ")
    site.save
  end
end
pbar.finish

byebug
puts ""