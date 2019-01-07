#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

expeditions = [
  "\"Operation Hazen\" - International Geophysical Year 1957-8",
  "Expedition de l'Arctic Institute; The Catholic University of America",
  "Canadian-Arctic Permafrost Expedition, 1951. Purdue University - Corps of Engineers, U.S.A.",
  "Arnold Arboretum Expedition to the Mackenzie Mountains, 1939",
  "Canadian Arctic Expedition",
  "Polar Continental Shelf Project",
  "Plants from Arctic Canada.  The 5th Thule Expedition 1921-24.",
  "The MacMillan Arctic Expedition",
  "Nueltin Lake Expedition, 1947",
  "Expedition to Isle Royale, Michigan, 1930",
  "Iter arcticus Roald Amundsen (Gjöa-Expedition) 1903-1906",
  "Arctic Archipelago and Ungava IX International Botanical Congress Arctic Field Trip"
]

activities = [
  "Swedish Arctic Research Programme-Tundra Northwest 1999",
  "Vegetation Survey along the Enterprise-Mackenzie River Highway",
  "Vegetation Survey along the Mackenzie River-Yellowknife Highway"
]

activities.each do |expedition|
  puts expedition
  event = Event.find_by_full_name(expedition)
  sites = Site.where({ research_activity: expedition })

  sites.find_each do |site|
    site_event = SiteEvent.where(event_id: event.id, site_id: site.id)
    if site_event.empty?
      site_event = SiteEvent.new
      site_event.site_id = site.id
      site_event.event_id = event.id
      site_event.save
    end

    object_ids = CatalogSite.where(site_id: site.id).pluck(:catalog_id)
    catalog_events = CatalogEvent.where(event_id: event.id).pluck(:catalog_id)

    (object_ids - catalog_events).each do |id|
      catalog_event = CatalogEvent.new
      catalog_event.catalog_id = id
      catalog_event.event_id = event.id
      catalog_event.save
    end
  end
end
