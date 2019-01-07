#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

group = Group.find_by_name("Zoology-Records with Multiple Taxonomies")

catalogs = Catalog.where(collection: Collection::ZOOLOGY)

pbar = ProgressBar.create(title: "TaxaCollections", total: catalogs.count, autofinish: false, format: '%t %b>> %i| %e')

catalogs.find_each do |o|
  pbar.increment
  next if o.taxa.count < 2
  gm = GroupMember.new
  gm.group_id = group.id
  gm.table_key = o.id
  gm.save
end

pbar.finish


