#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

sites = Site.where.not(utm_start: nil)

pbar = ProgressBar.create(title: "SITES", total: sites.count, autofinish: false, format: '%t %b>> %i| %e')

bits = []

sites.find_each do |site|
  pbar.increment
  matched = /NAD/.match(site.utm_start)
  if matched
    bits << site.utm_start
  end
end

pbar.finish
byebug
puts ""