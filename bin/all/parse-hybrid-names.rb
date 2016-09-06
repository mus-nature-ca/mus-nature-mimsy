#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

dt = DateTime.now.strftime("%Y-%m-%d-%H-%M")
dir_zip = output_dir(__FILE__) + "/export/mimsy-#{dt}"

parser = ScientificNameParser.new

#Create folder
Dir.mkdir(dir_zip)

#Create csv
CSV.open(dir_zip + "/TaxonHybrid.csv", 'w') do |csv|
  csv << ["id", "verbatim", "authority", "canonical", "rank", "parent1", "parent2"]
end

Parallel.map(Taxon.where(rank: "hybrid").in_groups_of(25, false), progress: "TaxonHybrid", in_processes: 8) do |group|
  CSV.open(dir_zip + "/TaxonHybrid.csv", 'a') do |csv|
    group.each do |name|
      next if name.rank != "hybrid"
      parsed = parser.parse(name.scientific_name)
      details = parsed[:scientificName][:details]
      next if !details.present?
      canonical = rank = nil
      parents = []
      details.each do |d|
        uninomial = d[:uninomial].present? ? d[:uninomial][:string] : nil
        genus = d[:genus].present? ? d[:genus][:string] : nil
        species = d[:species].present? ? d[:species][:string] : nil
        infraspecies = nil
        if d[:infraspecies].present?
          infraspecies = d[:infraspecies].map{|i| [i[:rank], i[:string]].join(" ").strip }.join(" ").strip
        end
        if /^[A-Z]\.$/.match(genus) && details.size > 1
          genus = details[0][:uninomial].present? ? details[0][:uninomial][:string] : details[0][:genus][:string]
        end
        parents << [uninomial, genus, species, infraspecies].join(" ").strip
      end
      if parents.size == 1
        canonical = parents[0]
        rank = (name.scientific_name[0] == "×") ? "genus" : "species"
        parents = [nil,nil]
      end
      csv << [name.id, name.scientific_name, name.authority, canonical, rank] + parents
    end
  end
end

#Create csv
CSV.open(dir_zip + "/TaxonVariationHybrid.csv", 'w') do |csv|
  csv << ["id", "verbatim", "authority", "canonical", "rank", "parent1", "parent2"]
end

Parallel.map(TaxonVariation.where("variation LIKE '%×%'").in_groups_of(25, false), progress: "TaxonVariationHybrid", in_processes: 8) do |group|
  CSV.open(dir_zip + "/TaxonVariationHybrid.csv", 'a') do |csv|
    group.each do |name|
      parsed = parser.parse(name.scientific_name)
      details = parsed[:scientificName][:details]
      next if !details.present?
      canonical = rank = nil
      parents = []
      details.each do |d|
        uninomial = d[:uninomial].present? ? d[:uninomial][:string] : nil
        genus = d[:genus].present? ? d[:genus][:string] : nil
        species = d[:species].present? ? d[:species][:string] : nil
        infraspecies = nil
        if d[:infraspecies].present?
          infraspecies = d[:infraspecies].map{|i| [i[:rank], i[:string]].join(" ").strip }.join(" ").strip
        end
        if /^[A-Z]\.$/.match(genus) && details.size > 1
          genus = details[0][:uninomial].present? ? details[0][:uninomial][:string] : details[0][:genus][:string]
        end
        parents << [uninomial, genus, species, infraspecies].join(" ").strip
      end
      if parents.size == 1
        canonical = parents[0]
        rank = (name.scientific_name[0] == "×") ? "genus" : "species"
        parents = [nil,nil]
      end
      csv << [name.id, name.scientific_name, nil, canonical, rank] + parents
    end
  end
end