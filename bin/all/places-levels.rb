#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

places = Place.where(political_name: true)
pbar = ProgressBar.create(title: "PLACE-POLITICAL", total: places.count, autofinish: false, format: '%t %b>> %i| %e')
CSV.open(output_dir(__FILE__) + "/place-level-political.csv", 'w') do |csv|
  csv << ["broader_text", "hierarchy_levels", "placekeys"]
  places.find_each do |place|
    pbar.increment
    next if !place.leaf?
    place_levels = place.ancestors_and_self.map{|o| [o.name, o.hierarchy_level, o.id]}
    next if place_levels.count == place_levels.collect{|ind| ind[1]}.compact.uniq.count
    csv << [place_levels.collect{|ind| ind[0]}.join("; "), place_levels.collect{|ind| ind[1] ||= "nil"}.join("|"), place_levels.collect{|ind| ind[2] ||= "nil"}.join("|")]
  end
end
pbar.finish

=begin
places = Place.where(geographic_name: true)
pbar = ProgressBar.create(title: "PLACE-GEOGRAPHIC", total: places.count, autofinish: false, format: '%t %b>> %i| %e')
CSV.open(output_dir(__FILE__) + "/place-level-geographic.csv", 'w') do |csv|
  csv << ["broader_text", "hierarchy_levels", "placekeys"]
  places.find_each do |place|
    pbar.increment
    next if !place.leaf?
    place_levels = place.ancestors_and_self.map{|o| [o.name, o.hierarchy_level, o.id]}
    next if place_levels.count == place_levels.collect{|ind| ind[1]}.compact.uniq.count
    csv << [place_levels.collect{|ind| ind[0]}.join("; "), place_levels.collect{|ind| ind[1] ||= "nil"}.join("|"), place_levels.collect{|ind| ind[2] ||= "nil"}.join("|")]
  end
end
pbar.finish
=end
