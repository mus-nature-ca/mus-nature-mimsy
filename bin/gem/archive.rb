#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

catalogs = Catalog.where(id: [473224, 549718, 549720, 549722, 549723, 549724])

Catalog.reflections.each do |reflection|
  file_name = reflection.first
  class_name = reflection.second.class_name
  items = catalogs.map{|obj| obj.send(file_name.to_sym) }

  CSV.open(output_dir(__FILE__) + "/gem-#{file_name}.csv", 'w') do |csv|
    csv << class_name.constantize.custom_attribute_names
    items.each do |item|
      if item.is_a? ActiveRecord::Associations::CollectionProxy
        item.each do |child|
          csv << child.custom_attributes.values
        end
      else
        if !item.nil?
          csv << item.custom_attributes.values
        end
      end
    end
  end

end

CSV.open(output_dir(__FILE__) + "/gem-catalog.csv", 'w') do |csv|
  csv << Catalog.custom_attribute_names
  catalogs.each do |catalog|
    csv << catalog.custom_attributes.values
  end
end