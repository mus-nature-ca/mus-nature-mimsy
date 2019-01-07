#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

groups = Group.where(group_owner: "DSHORTHOUSE", group_area: ["catalogue","sites"])

groups.find_each do |group|
  puts group.name
  group.members.pluck(:id).in_groups_of(1000, false) do |ids|
    GroupMember.where(id: ids).delete_all
  end
  group.destroy
end