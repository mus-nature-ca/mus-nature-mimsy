#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

ranks = ["species", "subspecies", "hybrid"]
places = ["Canada", "USA", "United States"]

bird = Taxon.find(501174) #Aves = 501174
birds = bird.descendants.collect{|d| d if ranks.include?(d.rank)}.compact

CSV.open(output_dir(__FILE__) + "/na-birds.csv", 'w') do |csv|
  csv << ["speckey", "scientific_name", "authority", "rank", "hierarchy", "total", "CA-US_total", "CA-US_breakdown"]
end

pattern = /^CMNAV\s*([A-Z])?[0-9]{1,}/

Parallel.map(birds.in_groups_of(10, false), progress: "Birds", in_processes: 8) do |group|
  CSV.open(output_dir(__FILE__) + "/na-birds.csv", 'a') do |csv|
    group.each do |bird|
      na_collections = []
      na_collections_type = {
        nil: 0,
        B: 0,
        E: 0,
        S: 0,
        T: 0,
        Z: 0
      }
      catalogs = bird.catalogs
      next if catalogs.empty?
      catalogs.each do |catalog|
        next if catalog.collection != "Bird"
        places.each do |place|
          if catalog.place_collected && catalog.place_collected.include?(place)
            na_collections << catalog.id_number
          end
        end
      end
      na_collections_type = nil if na_collections.empty?
      na_collections.each do |na_collection|
        match = na_collection.match(pattern)
        if match
          type = !match[1].nil? ? match[1] : 'nil'
          na_collections_type[type.to_sym] += 1
        end
      end
      csv << [bird.speckey, bird.scientific_name, bird.authority, bird.rank, bird.parent_path, catalogs.count, na_collections.count, na_collections_type]
    end
  end
end
