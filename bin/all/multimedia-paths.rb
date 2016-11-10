#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

media = []

Medium.find_each do |item|
  begin
    item.locator.sub!("\\\\n-fs1", "\\\\\\n-nas1")
    item.save
  rescue
    media << item.media_id
  end
end