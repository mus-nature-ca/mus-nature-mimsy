#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

catalogs = ["CAN 291513", "CAN 38254", "CAN 38252", "CAN 38251"]

CSV.open(output_dir(__FILE__) + "/Greenland_Festuca.csv", 'w') do |csv|
  csv << [
    "id_number",
    "label_name",
    "taxon_link",
    "ident",
    "id_date",
    "type_status",
    "higher_taxa",
    "count",
    "sex",
    "coll_num",
    "collector",
    "place_collected",
    "date_collected",
    "spec_nature",
    "description",
    "acq_number",
    "site_desc",
    "altitude",
    "lat",
    "long",
    "site_notes",
    "home_loc"
  ]
end

Parallel.map(catalogs.in_groups_of(40, false), progress: "Catalogs", in_processes: 8) do |group|
  CSV.open(output_dir(__FILE__) + "/Greenland_Festuca.csv", 'a') do |csv|
    group.each do |id|
      catalog = Catalog.find_by_catalog_number(id.strip)
      id_number = catalog.catalog_number
      label_name = catalog.scientific_name
      taxon_link = catalog.catalog_taxa.first.scientific_name rescue nil
      ident = catalog.catalog_taxa.first.identified_by rescue nil
      id_date = catalog.catalog_taxa.first.date_identified.to_s rescue nil
      type_status = catalog.catalog_taxa.first.type_status rescue nil
      higher_taxa = catalog.catalog_taxa.first.higher_taxonomy rescue nil
      count = catalog.item_count.to_s
      sex = catalog.sex
      coll_num = catalog.other_numbers.map{|other| other.other_number if other.on_type == "collector no./field no."}.first.to_s rescue nil
      collector = catalog.collector
      place_collected = catalog.place_collected
      date_collected = catalog.date_collected.to_s
      spec_nature = catalog.specimen_nature
      description = catalog.description
      acq_number = catalog.acquisition_number.to_s
      site_desc = catalog.sites.first.description rescue nil
      altitude = catalog.sites.first.elevation.to_s rescue nil
      lat = catalog.sites.first.start_latitude_dec.to_f rescue nil
      long = catalog.sites.first.start_longitude_dec.to_f rescue nil
      #p_s = catalog.sites.first.decimal_is_primary? ? "P" : "S" rescue nil
      site_notes = catalog.sites.first.recommendations rescue nil
      home_loc = catalog.home_location
      csv << [
        id_number,
        label_name,
        taxon_link,
        ident,
        id_date,
        type_status,
        higher_taxa,
        count,
        sex,
        coll_num,
        collector,
        place_collected,
        date_collected,
        spec_nature,
        description,
        acq_number,
        site_desc,
        altitude,
        lat,
        long,
        site_notes,
        home_loc
      ]
    end
  end
end