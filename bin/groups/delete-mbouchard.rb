#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

group_ids = [
  1337,
  2017,
  3143,
  3144,
  3423,
  3582,
  3888,
  3946,
  3961,
  3994
]

Group.where(id: group_ids).find_each do |g|
  g.group_name = g.group_name << " [#{g.group_owner}]"
  g.group_owner = "YDARE"
  g.save
end