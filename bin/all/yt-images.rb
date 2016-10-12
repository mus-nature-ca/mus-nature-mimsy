#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

place = Place.find_by_name("Yukon Territory")
plants = Catalog.joins(:catalog_collection_places).where(collection: "Vascular Plant").where("items_places_collected.placekey = #{place.id}")
pbar = ProgressBar.create(title: "Yukon", total: plants.count, autofinish: false, format: '%t %b>> %i| %e')

specimens = []

plants.find_each do |catalog|
  pbar.increment
  if catalog.collection_places.map(&:id).include?(13)
    specimens << catalog.catalog_number
  end
end
pbar.finish

byebug
puts ""

CSV.open(output_dir(__FILE__) + "/yt-specimens.csv", 'w') do |csv|
  csv << Catalog.custom_attribute_names
  collections.find_each do |cp|
    pbar.increment
    catalog = cp.catalog
#    if catalog && catalog.has_image?
    if catalog && catalog.collection == "Vascular Plant"
      csv << catalog.custom_attributes.values
#      catalog.media.each do |media|
#        source = File.join("/Volumes/dept/", media.locator_linux, media.media_id)
#        FileUtils.cp(source, destination)
#      end
    end
  end
end

pbar.finish
