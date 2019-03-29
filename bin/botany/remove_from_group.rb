#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

name = "scientific name to be updated"
group = Group.find_by_name(name)

catalog_numbers = (10574..69634).map{|i| "CAN #{i}"}

catalog_numbers.in_groups_of(50, false) do |n|
  catalog_ids = Catalog.where(catalog_number: n).pluck(:id)
  group.members.where(table_key: catalog_ids).destroy_all
end