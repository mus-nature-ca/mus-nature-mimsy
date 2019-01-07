#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/Canadian-scarabs-species file.txt"

superfamily_id = 1180230

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|
  family = row["Family"].strip rescue nil
  subfamily = row["Subfamily"].strip rescue nil
  tribe = row["Tribe"].strip rescue nil
  subtribe = row["Subtribe"].strip rescue nil
  genus = row["Genus"].strip rescue nil
  species = row["Species"].strip rescue nil
  author = row["Author_year"].strip rescue nil
  scientific_name = [genus,species].join(" ")

  scientific_name_record = Taxon.find_by_scientific_name(scientific_name)

  if scientific_name_record.nil?
    genus_record = Taxon.find_by_scientific_name(genus)
    t = Taxon.new
    t.scientific_name = scientific_name
    t.taxon_name = "Zoology"
    t.level_text = "species"
    t.hierarchy_level = 29
    t.source = author
    t.parent_id = genus_record.id
    t.save
  end

end