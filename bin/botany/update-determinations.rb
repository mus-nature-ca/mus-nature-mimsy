#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/MXG updates 2018.02.txt"
output_file = "/Users/dshorthouse/Desktop/MXG updates 2018.02-log.csv"
  
CSV.open(output_file, 'w') do |csv|
  csv << ["ID Number", "Original Det", "Original SpecKey", "Determiner", "New Det", "Determination Date", "New SpecKey", "Summary"]
  CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|
    catalog_id = row["ID Number"]
    original_det = row["Original Det"]
    original_speckey = row["Original SpecKey"].to_i
    determiner = row["Determiner"]
    new_det = row["New Det"]
    new_det_date = row["Determination Date"]
    new_speckey = row["New SpecKey"].to_i
    catalog = Catalog.find_by_catalog(catalog_id) rescue nil
    summary = ""

    #logic here for all the data
    if catalog.nil?
      summary = "ID Number not found"
      csv << [catalog_id, original_det, original_speckey, determiner, new_det, new_det_date, new_speckey, summary]
      next
    elsif catalog.catalog_taxa.count > 1
      summary = "2+ taxa found for ID Number"
      csv << [catalog_id, original_det, original_speckey, determiner, new_det, new_det_date, new_speckey, summary]
      next
    elsif catalog.catalog_taxa.count == 1 && catalog.catalog_taxa.first.taxon_id != original_speckey
      summary = "Not original Speckey as indicated"
      csv << [catalog_id, original_det, original_speckey, determiner, new_det, new_det_date, new_speckey, summary]
      next
    elsif catalog.catalog_taxa.count == 1 && catalog.catalog_taxa.first.taxon_id == original_speckey
      #Add current det as new row if needed
      current_det = catalog.catalog_taxa.first
      existing_catalog_name = CatalogName.where(
        {
          mkey: catalog.id, 
          scientific_name: current_det.scientific_name.gsub(/^(x{2}|X{2})/,''),
          attributor: current_det.attributor,
          attrib_date: current_det.attrib_date
        })

      if existing_catalog_name.empty?
        cn = catalog.names.new
        cn.scientific_name = current_det.taxonomy.gsub(/^(x{2}|X{2})/,'')
        cn.attributor = current_det.attributor
        cn.attrib_date = current_det.attrib_date
        if current_det.taxonomy.gsub(/^(x{2}|X{2})/,'') != new_det
          cn.prior_name = true
        end
        cn.save
      end

      #Add new det to the history
      cn = catalog.names.new
      cn.scientific_name = new_det
      cn.attributor = determiner
      cn.attrib_date = new_det_date
      cn.save

      #Update link to taxonomy
      ct = catalog.catalog_taxa.first
      ct.taxon_id = new_speckey
      ct.attributor = determiner
      ct.attrib_date = new_det_date
      ct.save

      #Update the scientific name
      catalog.item_name = new_det
      catalog.save

      #Add to existing Group (id = 4500, group_name = "Floristics (2007)") if not present
      # GroupID = 4673 is "Coppermine Paper"
      group_count = GroupMember.where({ group_id:4673, table_key: catalog.id }).count
      if group_count == 0
        group_member = GroupMember.new
        group_member.group_id = 4673
        group_member.table_key = catalog.id
        group_member.save
      end

      summary = "updated"
      csv << [catalog_id, original_det, original_speckey, determiner, new_det, new_det_date, new_speckey, summary]
      next
    else
      summary = "not updated"
      csv << [catalog_id, original_det, original_speckey, determiner, new_det, new_det_date, new_speckey, summary]
    end
  end
end

