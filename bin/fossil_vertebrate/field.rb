#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

objs = Catalog.where(acquisition_number: "FIELD")
pbar = ProgressBar.create(title: "FIELD", total: objs.count, autofinish: false, format: '%t %b>> %i| %e')

objs.find_each do |obj|
  pbar.increment
  if !obj.acquisition
    obj.acquisition_number = nil
    obj.save
  else
    byebug
  end
end

pbar.finish
