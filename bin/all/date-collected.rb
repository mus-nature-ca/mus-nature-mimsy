#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

candidates = []

objs = Catalog.where.not(date_collected: nil)
pbar = ProgressBar.create(title: "Date Collected", total: objs.count, autofinish: false, format: '%t %b>> %i| %e')

objs.find_each do |obj|
  pbar.increment
  dates = obj.date_collected.split(" - ")
  d = Chronic.parse(dates[0])
  if d && d.year.between?(1860,1870)
    candidates << obj.catalog_number
  end
end
pbar.finish

byebug
puts ""

# Random bits of disconnected regex material to sus out issues with collection dates

=begin
  matches = %r{
    ^\d{4}$|
    ^\d{4}\-\d{2}$|
    ^\d{4}\-\d{2}\-\d{2}$|
    ^\d{4}\s{1}\-\s{1}\d{4}$|
    ^\d{4}\-\d{2}\s{1}\-\s{1}\d{4}\-\d{2}$|
    ^\d{4}\-\d{2}\-\d{2}\s{1}\-\s{1}\d{4}\-\d{2}\-\d{2}$|
    ^\d{4}\s{1}(summer|winter|fall|spring)$|
    ^\d{4};\s{1}\d{4}$|
    ^\d{4}\-\d{2};\s{1}\d{4}\-\d{1}$|
    ^\d{4}\-\d{2}\-\d{2};\s{1}\d{4}\-\d{2}\-\d{2}$|
    ^\d{4}\-\d{2}\-\d{2};\s{1}time\:\s{1}\d{2}\:\d{2}$|
    ^\d{4}\-\d{2}\-\d{2};\s{1}time\:\s{1}\d{2}\:\d{2}\-\d{2}\:\d{2}$|
    ^\d{4}\-\d{2}\-\d{2};\s{1}time\:\s{1}\d{2}\:\d{2};\s{1}duration\:\s{1}.*
  }x

    matched = matches.match obj.date_collected
    if !matched
      csv << [obj.date_collected]
    end
  
  end


cats = Catalog.joins("LEFT JOIN date_collected ON date_collected.mkey = catalogue.mkey").where.not(date_collected: nil).where("date_collected.mkey IS NULL")

dates = CollectedDate.group(:mkey).having("count(*) > 1").count

pbar = ProgressBar.create(title: "Date Collected", total: dates.size, autofinish: false, format: '%t %b>> %i| %e')

CSV.open(output_dir(__FILE__) + "/many-dates.csv", 'w') do |csv|
  csv << ["collection", "id_number", "num_collection_dates"]
  dates.each do |date|
    pbar.increment
    obj = Catalog.find(date[0]) rescue nil
    next if obj.nil?
    next if !["Alga", "Bryophyte", "Lichen", "Vascular Plant"].include?(obj.collection)
    next if !/\s\-\s/.match(obj.date_collected).nil?
    csv << [obj.collection, obj.catalog_number, date[1]]
  end
end
pbar.finish

Catalog.find_each do |item|
  pbar.increment
  if item.date_collected
    valid_date = []
    dates = item.date_collected.split(" - ")
    dates.each do |date|
      d = Chronic.parse(date)
      valid_date << date if d
    end
    cleaned = valid_date.join("/")
    byebug
  end
end
pbar.finish
=end