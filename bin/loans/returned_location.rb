#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

problems = []

loans = Loan.where(status: "closed")

pbar = ProgressBar.create(title: "Loans", total: loans.count, autofinish: false, format: '%t %b>> %i| %e')
loans.each do |loan|
  pbar.increment
  num = loan.loan_number
  problems << loan.loan_catalogs
                  .where(status: "returned")
                  .map{ |o| o.catalog.catalog_number if o.catalog.location.include?(num) rescue nil }
                  .compact
end
pbar.finish

byebug
puts ""