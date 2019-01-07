#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

media = Medium.where("locator LIKE '\\\\n-nas1.mus-nature.ca\\BotanySpecimenImages\\%'")

media.each do |m|
  m.locator.gsub!("BotanySpecimenImages", "dept\\BotanySpecimenImages")
  m.save
  puts m.media_id
end