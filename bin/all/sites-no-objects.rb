#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

group = Group.find_by_name("Sites with Location and no Objects")

all_sites = Site.pluck(:id)
sites_with_objects = CatalogSite.pluck(:site_id).compact.uniq
sites_with_places = PlaceSite.pluck(:site_id).compact.uniq
sites_no_objects = all_sites - sites_with_objects - sites_with_places

sites_with_location = []

sites_no_objects.in_groups_of(500, false).each do |group|
  sites_with_location << Site.where(id: group).where.not(location: nil).pluck(:id)
end

sites_with_location.flatten.each do |id|
  gm = GroupMember.new
  gm.group_id = group.id
  gm.table_key = id
  gm.save
end