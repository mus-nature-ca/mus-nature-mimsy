module Sinatra
  module Mimsy
    module Model
      module Initialize
        module ModelUtility
          extend ActiveSupport::Concern

          included do

            def self.to_csv
              CSV.generate(headers: true) do |csv|
                csv << custom_attribute_names
                all.each do |row|
                  csv << row.attributes.values
                end
              end
            end

          end
        end
      end
    end
  end
end

module ActiveRecord
  class Base

    def self.custom_attribute(new_attribute, old_attribute)
      alias_attribute new_attribute, old_attribute
      custom_attribute_names.map! { |x| x == old_attribute.to_s ? new_attribute.to_s : x }
    end

    def self.custom_attribute_names
      @custom_attribute_names ||= attribute_names.dup
    end

  end
end