#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

hybrids = TaxonVariation.where("variation like 'x%'")
pbar = ProgressBar.create(title: "Hybrids", total: hybrids.count, autofinish: false, format: '%t %b>> %i| %e')

hybrids.find_each do |hybrid|
  matched = /^x[A-Z]/.match(hybrid.variation)
  byebug if matched
end

pbar.finish