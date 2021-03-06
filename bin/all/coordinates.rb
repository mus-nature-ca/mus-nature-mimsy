#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

@skeys = []
pbar = ProgressBar.create(title: "Coordinates", total: Site.count, autofinish: false, format: '%t %b>> %i| %e')

def add_record(csv, item, problem)
  if !@skeys.include?(item.skey)
    csv << [item.skey, item.site_id, item.start_latitude, item.start_longitude, item.start_latitude_dec, item.start_longitude_dec, problem]
    @skeys << item.skey
  end
end

CSV.open(output_dir(__FILE__) + "/coordinates.csv", 'w') do |csv|
  csv << ["skey", "site_id", "start_latitude", "start_longitude", "start_latitude_dec", "start_longitude_dec", "problem"]
  Site.find_each do |item|
    pbar.increment
    lat = item.start_latitude
    lng = item.start_longitude
    lat_d = item.start_latitude_dec ? item.start_latitude_dec.to_f : nil
    lng_d = item.start_longitude_dec ? item.start_longitude_dec.to_f : nil
    if (item.start_latitude.present? && !item.start_longitude.present?) || (!item.start_latitude.present? && item.start_longitude.present?)
      add_record(csv, item, "incomplete pair")
    end
    if lat_d && lng_d && (lat_d == 0 || lng_d == 0 || lat_d > 90 || lat_d < -90 || lng_d > 180 || lng_d < -180)
      add_record(csv, item, "off Earth or 0,0")
    end
    if item.start_latitude && item.start_longitude
      parsed_lat = item.start_latitude.gsub(/[NEWS]/,'').split(/[°'"]/).map{|c| c.strip}.reject(&:empty?)
      parsed_lng = item.start_longitude.gsub(/[NEWS]/,'').split(/[°'"]/).map{|c| c.strip}.reject(&:empty?)
      if parsed_lat[0].to_f > 90 || parsed_lat[0].to_f < -90 || parsed_lng[0].to_f > 180 || parsed_lng[0].to_f < -180
        add_record(csv, item, "degrees impossible")
      end
      if (parsed_lat[1].present? && parsed_lat[1].to_f >= 60) || (parsed_lng[1].present? && parsed_lng[1].to_f >= 60)
        add_record(csv, item, "minutes too large")
      end
      if (parsed_lat[2].present? && parsed_lat[2].to_f >= 60) || (parsed_lng[2].present? && parsed_lng[2].to_f >= 60)
        add_record(csv, item, "seconds too large")
      end
    end
  end
end
pbar.finish