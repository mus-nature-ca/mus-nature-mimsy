#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

events = [
  "xxCanadian Arctic Expedition: Southern Party",
  "xxCanadian Arctic Expedition: Northern Party",
  "xxCanadian Arctic Expedition, 1913-1916"
]

destination_name = "Canadian Arctic Expedition"
event_destination = Event.find_by_full_name(destination_name)

events.each do |e|
  event = Event.find_by_full_name(e)

  site_event_ids = SiteEvent.where(event_id: event.id).pluck(:site_id)
  site_event_ids.each do |id|
    existing = SiteEvent.where(event_id: event_destination.id, site_id: id)
    if existing.empty?
      se = SiteEvent.new
      se.event_id = event_destination.id
      se.site_id = id
      se.save
    end
  end
  SiteEvent.where(event_id: event.id).destroy_all

  catalog_event_ids = CatalogEvent.where(event_id: event.id).pluck(:catalog_id)
  catalog_event_ids.each do |id|
    existing = CatalogEvent.where(event_id: event_destination.id, catalog_id: id)
    if existing.empty?
      ce = CatalogEvent.new
      ce.event_id = event_destination.id
      ce.catalog_id = id
      ce.save
    end
  end
  CatalogEvent.where(event_id: event.id).destroy_all

end