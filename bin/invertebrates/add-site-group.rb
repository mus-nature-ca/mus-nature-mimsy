#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

group = Group.find_by_name("SitesManyCatalogsDifferDatesCollectors")

site_ids = []

site_ids.each do |id|
  site = Site.find_by_site_id(id) rescue nil
  if !site.nil?
    gm = GroupMember.new
    gm.group_id = group.id
    gm.table_key = site.id
    gm.save
  end
  puts id if site.nil?
end