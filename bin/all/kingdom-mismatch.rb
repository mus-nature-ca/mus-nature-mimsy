#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

taxon_map = {
  "Zoology" => [
    "Casts and Molds",
    "Fossil Vertebrate",
    "Amphibian and Reptile",
    "Insect",
    "Annelid",
    "Crustacea",
    "Fish",
    "Mollusc",
    "Mammal",
    "NU Fossil Invertebrate",
    "NU Fossil Vertebrate",
    "General Invertebrate",
    "Bird",
    "Fossil Invertebrate",
    "Parasite"
  ],
  "Botany" => [
    "Lichen",
    "Vascular Plant",
    "Bryophyte",
    "Palaeobotany",
    "Palynology",
    "Alga"
  ]
}

pbar = ProgressBar.create(title: "Kingdom Mismatch", total: Catalog.count, autofinish: false, format: '%t %b>> %i| %e')

CSV.open(output_dir(__FILE__) + "/kingdom-mismatch.csv", 'w') do |csv|
  csv << ["mkey", "Collection", "ID Number"]
  Catalog.find_each do |cat|
    pbar.increment
    taxon_collections = cat.taxa.map(&:collection).uniq
    taxon_collections.each do |tc|
      if !taxon_map[tc].include? cat.collection
        byebug
        csv << [cat.mkey, cat.collection, cat.id_number]
      end
    end
  end
end
pbar.finish