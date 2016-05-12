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
  module ConnectionAdapters
    module OracleEnhanced
      module DatabaseStatements
        # Override method such that RETURNING statement does not get appended for views
        def sql_for_insert(sql, pk, id_value, sequence_name, binds)
          blacklist = ["authlinkkey"]
          unless id_value || pk.nil? || blacklist.include?(pk) || 
            (defined?(CompositePrimaryKeys) && pk.kind_of?(CompositePrimaryKeys::CompositeKeys))
            sql = "#{sql} RETURNING #{quote_column_name(pk)} INTO :returning_id"
            returning_id_col = new_column("returning_id", nil, Type::Value.new, "number", true, "dual", true, true)
            (binds = binds.dup) << [returning_id_col, nil]
          end
          [sql, binds]
        end
      end
    end
  end

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