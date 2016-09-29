#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

place = Place.find_by_name("Yukon Territory")
collections = CatalogCollectionPlace.where(place_id: place.id)
pbar = ProgressBar.create(title: "Date Collected", total: collections.size, autofinish: false, format: '%t %b>> %i| %e')
destination = File.join(output_dir(__FILE__), "yt-images")

CSV.open(output_dir(__FILE__) + "/yt-specimens.csv", 'w') do |csv|
  csv << Catalog.custom_attribute_names
  collections.find_each do |cp|
    pbar.increment
    catalog = cp.catalog
    if catalog && catalog.has_image?
      csv << catalog.custom_attributes.values
      catalog.media.each do |media|
        source = File.join("/Volumes/dept/", media.locator_linux, media.media_id)
        FileUtils.cp(source, destination)
      end
    end
  end
end

pbar.finish
