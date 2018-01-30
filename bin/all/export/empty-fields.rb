#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../../environment.rb'
require_relative '../../../lib/export.rb'

include Sinatra::Mimsy::Helpers

models = ActiveRecord::Base.descendants
models.delete_if{|m| Export::EXCLUSIONS.include?(m.name)}

@file = output_dir(__FILE__) + "/empty-fields.csv"
@mappings_dir = File.join(ENV['PWD'], 'migration_mappings', "original")

CSV.open(@file, 'w') do |csv|
  csv << ["model", "attribute", "count"]
end

Parallel.map(models.in_groups_of(5, false), progress: "Empty", in_processes: 5) do |group|
  CSV.open(@file, 'a') do |csv|
    group.each do |model|
      if File.file?(File.join(@mappings_dir, "#{model.name}.yaml"))
        mappings = YAML.load_file(File.join(@mappings_dir, "#{model.name}.yaml"))
        attributes = model.custom_attribute_names.map(&:to_sym)
        mappings.each do |m|
          if attributes.include?(m.first) && m.second[:module].empty? && m.second[:instructions].empty?
            count = model.where.not(m.first => nil).count
            if count < 6
              csv << [model.name, m.first, count]
            end
          end
        end
      end
    end
  end
end
