#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

Parallel.each(Site.find_in_batches, progress: "Sites") do |array_of_instances|
  array_of_instances.each do |site|

    site_other_number = site.other_numbers.where(site_othnum_type: "Collector field number").first
    field_number = site_other_number.other_number rescue nil
    next if field_number.nil?

    other_numbers = []
    collection = []
    site.catalogs.find_each do |o|
      other_numbers << o.other_numbers.where(on_type: "collector no./field no.").pluck(:other_number).first rescue nil
      collection << o.collection
    end

    next if collection.uniq.count > 1 || !Collection::BOTANY.include?(collection.uniq.first)

    if other_numbers.uniq.include?(field_number)
      site_other_number.destroy
    end

  end
end