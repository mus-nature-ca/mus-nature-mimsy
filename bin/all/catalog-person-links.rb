#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

pbar = ProgressBar.create(title: "PersonLinks", total: Catalog.count, autofinish: false, format: '%t %b>> %i| %e')

#Remove all existing entries
CatalogPerson.where.not(catalog_name_id: nil).delete_all
CatalogPerson.where.not(catalog_taxon_id: nil).delete_all

Catalog.find_each do |catalog|
  pbar.increment

  catalog.catalog_taxa.each do |tax|
    if !tax.attributor.nil?
      tax_people = tax.attributor.split("; ")
      tax_people.each do |tax_person|
        person = Person.where(preferred_name: tax_person)
        if person.empty?
          person = PersonVariation.where(variation: tax_person)
        end

        if person.size == 1
          cp = CatalogPerson.new
          cp.link_id = person.first.link_id
          cp.mkey = catalog.mkey
          cp.catalog_taxon_id = tax.id
          cp.save
        end

      end
    end
  end

  catalog.determinations.each do |det|
    if !det.attributor.nil?
      det_people = det.attributor.split("; ")
      det_people.each do |det_person|
        person = Person.where(preferred_name: det_person)
        if person.empty?
          person = PersonVariation.where(variation: det_person)
        end
        if person.size == 1
          cp = CatalogPerson.new
          cp.link_id = person.first.link_id
          cp.mkey = catalog.mkey
          cp.catalog_name_id = det.id
          cp.save
        end
      end
    end
  end
  
end

pbar.finish