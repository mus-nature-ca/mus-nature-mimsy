#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

catalogs = Catalog.where(place_collected: nil).where.not(site: nil).where("site NOT LIKE '%NO SITE%'").where("site NOT LIKE '%unknown%'")

problems = []

catalogs.each do |catalog|
  if !catalog.sites.map{|l| l.location}.compact.empty?
    problems << catalog.catalog_number
  end
end

byebug
puts ""


CANM 197355
CANM 197366
CANM 197404
CANM 197410
CANM 24086
CANM 25092
CANL 121941
CANM 148313
CAN 70582
CAN 393541
CMNAV 81110
CANM 8669
CMNFI 1968-1029.1