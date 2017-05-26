#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

#site_id = 474901 is "NO SITE", find Sites with more than one catalog
skeys = CatalogSite.where.not(site_id: 474901).group(:skey).having('count(*) > 1').count.keys

Parallel.map(skeys.in_groups_of(10, false), progress: "Problems", in_processes: 4) do |group|
  group.each do |skey|
    site = Site.find(skey)
    catalog_ids = site.catalog_sites.pluck(:catalog_id)
    place_ids = []
    catalog_ids.in_groups_of(30, false).each do |group|
      place_ids << CatalogCollectionPlace.where(catalog_id: group).pluck(:place_id).uniq
    end

    uniq_place_ids = place_ids.reduce(:+).uniq
    if uniq_place_ids.count > 1
      ancestors = uniq_place_ids.map{|u| { place_id: u, ancestors: Place.find(u).ancestors.map(&:placekey) } }
      uniq_place_ids.each do |place_id|
        if ancestors.map{|a| a[:ancestors]}.flatten.uniq.include?(place_id)
          found = ancestors.select{|a| a[:ancestors].include?(place_id)}
          if found.count == 1
            begin
              matching_catalog_ids = CatalogCollectionPlace.where(place_id: found.first[:place_id]).pluck(:catalog_id) & catalog_ids
              matching_catalog = Catalog.find(matching_catalog_ids.first)
              catalog_ids = CatalogCollectionPlace.where(place_id: place_id).pluck(:catalog_id) & catalog_ids
              catalog_ids.each do |id|
                catalog = Catalog.find(id)
                if catalog.date_collected == matching_catalog.date_collected && catalog.collector == matching_catalog.collector
                  catalog.place_collected = matching_catalog.place_collected
                  catalog.save
                  catalog.collection_places.destroy_all
                  cp = CatalogCollectionPlace.new
                  cp.catalog_id = catalog.id
                  cp.place_id = found.first[:place_id]
                  cp.save
                end
              end
            rescue
            end
          end
        end
      end
    end
  end
end
