#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers
require "pp"

term = "Total length"

measurements = CatalogMeasurement.where("part_measured LIKE '%#{term}%'")

pbar = ProgressBar.create(title: "Measurements", total: measurements.count, autofinish: false, format: '%t %b>> %i| %e')
measurements.find_each do |cm|
  pbar.increment
  cm.part_measured.gsub!(/#{term}/,term.downcase).strip
  cm.save
end
pbar.finish