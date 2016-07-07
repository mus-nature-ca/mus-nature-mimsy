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
                  csv << row.custom_attributes.values
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
  module ConnectionAdapters
    module OracleEnhanced
      module DatabaseStatements
        # Override method such that RETURNING statement does not get applied
        def sql_for_insert(sql, pk, id_value, sequence_name, binds)
          [sql, binds]
        end
      end
    end
  end

  class Base

    def custom_attributes
      Hash[self.class.custom_attribute_names.zip attributes.values]
    end

    def self.created_between(start_date, end_date)
      where("create_date >= ? AND create_date <= ?", start_date, end_date )
    end

    def self.updated_between(start_date, end_date)
      where("update_date >= ? AND update_date <= ?", start_date, end_date )
    end

    def self.custom_attribute(new_attribute, old_attribute)
      alias_attribute new_attribute, old_attribute
      custom_attribute_names.map! { |x| x == old_attribute.to_s ? new_attribute.to_s : x }
    end

    def self.custom_attribute_names
      @custom_attribute_names ||= attribute_names.dup
    end

  end
end