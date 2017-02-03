#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

require "pp"; pp Catalog.joins(:catalog_sites).group("catalogue.mkey").where("catalogue.category1": Collection::BOTANY).count.map{|c| Catalog.find(c[0]).catalog_number if c[1] > 1}.compact
