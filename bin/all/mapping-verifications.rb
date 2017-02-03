#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

MANY_MANY = {
  "Disposal" => "ref_number",
  "Event" => "full_name",
  "Facility" => "location",
  "Medium" => "media_id",
  "Person" => "preferred_name",
  "Place" => "placekey",
  "Publication" => "title",
  "Site" => "site_id",
  "Subject" => "subject",
  "Taxon" => "speckey"
}

models = ActiveRecord::Base.descendants
models.delete_if{|m| !m.name.include?("Catalog") || m.name == "Catalog"}

models.each do |m|
  parent = m.name.sub("Catalog","")
  if MANY_MANY.key?(parent)
    key = m.attribute_names[m.custom_attribute_names.find_index("catalog_id")]
    key2 = m.attribute_names[m.custom_attribute_names.find_index("#{parent}_id".downcase)]
    parent_column = MANY_MANY[parent]
    catalogs = m.where.not(catalog_id: nil).where.not(catalog_id: 0).group(key.to_sym).order('count_all desc').count.first(2)
    puts catalogs.map{|o| { "id_number" => Catalog.find(o[0]).catalog_number, "#{parent}" => m.where(catalog_id: o[0]).pluck(key2.to_sym).map{|s| parent.constantize.send("find_by_#{key2}".to_sym, s).send(parent_column.to_sym)}}}
  end
end