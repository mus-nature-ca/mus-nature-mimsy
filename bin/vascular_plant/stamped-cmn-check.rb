#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

other_mkeys = CatalogOtherNumber.where(on_type: "stamped CMN accession number").pluck(:mkey)
vp_mkeys = Catalog.where(collection: "Vascular Plant").pluck(:mkey)

(vp_mkeys - other_mkeys).each do |mkey|
  group_member = GroupMember.new
  group_member.group_id = 4707
  group_member.table_key = mkey
  group_member.save
end

byebug
puts ""

=begin

pbar = ProgressBar.create(title: "OTHERS", total: other_numbers.count, autofinish: false, format: '%t %b>> %i| %e')
issues = []

other_numbers.each do |n|
  catalog = Catalog.find_by_catalog_number(n)
  byebug if !catalog.nil?
  pbar.increment
end

pbar.finish

=end

