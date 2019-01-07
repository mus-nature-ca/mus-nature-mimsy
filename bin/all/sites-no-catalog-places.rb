#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

log = "/Users/dshorthouse/Desktop/sites-candidate-places.csv"
group = Group.find_by_name("Sites with Location and no Objects")

CSV.open(log, 'w') do |csv|
  csv << ["skey", "site_id", "site_name", "location", "candidate_place", "placekey"]

  group.members.each do |record|
    site = Site.find(record.table_key)
    location_parts = site.location.split(/[,:;]/).map(&:strip)
    place = nil
    candidate_places = Place.where(name: location_parts.last)
    if candidate_places.length == 0
      #Check in variant places for a single match
      place_variants = PlaceVariation.where(variation: location_parts.last)
      if place_variants.length == 1
        place = place_variants.first.place
      end
    end
    if candidate_places.length == 1
      place = candidate_places.first
    end
    if candidate_places.length > 1
      #What to do when we have more than one hit? Walk the hierarchy? How?
    end
    if !place.nil?
      csv << [site.id, site.site_id, site.site_name, site.location, place.name, place.id]
    else
      csv << [site.id, site.site_id, site.site_name, site.location, nil, nil]
    end
  end

end
