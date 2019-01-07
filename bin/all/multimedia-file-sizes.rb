#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

files = Medium.where("locator LIKE '%BotanySpecimenImages%'")

pbar = ProgressBar.create(title: "Media", total: files.count, autofinish: false, format: '%t %b>> %i| %e')

CSV.open(output_dir(__FILE__) + "/multimedia-file-size.csv", 'w') do |csv|
  csv << Medium.custom_attribute_names.push("file_size")

  files.find_each do |m|
    pbar.increment
    file_path = File.join(m.locator_mac, m.media_id)
    file_size = File.size(file_path) rescue nil
    csv << m.custom_attributes.values.push(file_size)
  end
end

pbar.finish