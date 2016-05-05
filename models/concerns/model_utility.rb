module Sinatra
  module Mimsy
    module Model
      module Initialize
        module ModelUtility
          extend ActiveSupport::Concern

          included do

            def self.to_csv
              CSV.generate(headers: true) do |csv|
                csv << attribute_names
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