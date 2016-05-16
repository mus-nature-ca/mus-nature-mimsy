#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

ARGV << '-h' if ARGV.empty?

options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: ghost-links.rb [options]"

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end

  opts.on("-m", "--model [MODEL]", String, "Join model to check for ghost links") do |model|
    options[:model] = model
  end

  opts.on("-a", "--attribute [ATTRIBUTE]", String, "Joining attribute") do |attribute|
    options[:attribute] = attribute
  end

  opts.on("-s", "--source [MODEL]", String, "Source model against which keys must exist") do |source|
    options[:source] = source
  end
end.parse!

if options[:model] && options[:attribute] && options[:source]
  model = options[:model].constantize
  source = options[:source].constantize
  attribute = options[:attribute]
  model_attributes = model.pluck(attribute).uniq.compact
  source_attributes = source.pluck(attribute).uniq.compact
  ghosts = model_attributes - source_attributes
  #TODO: deal with these ghost entries in JOIN tables somehow?
  if ghosts.size > 0
    byebug
    puts ""
    #model.where("#{attribute}": ghosts).delete_all [BEFORE DELETING, MIGHT BE DATA HERE!!]
  else
    puts "No ghost entries"
  end
else
  puts opts
  exit
end