#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

group = Group.find_by_group_name("Orphan CMNFV sites to delete")

with_catalogs = []

group.members.each do |member|
  site = Site.find(member[:table_key])
  puts site.site_id
  if site.catalogs.count > 0
    with_catalogs << site.site_id
  else
    site.destroy
    member.destroy
  end
end

byebug
puts ""