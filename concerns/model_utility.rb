module ModelUtility

  extend ActiveSupport::Concern

  def custom_attributes
    Hash[self.class.custom_attribute_names.zip attributes.values]
  end

  class_methods do

    def created_between(start_date, end_date)
      where("create_date >= ? AND create_date <= ?", start_date, end_date )
    end

    def updated_between(start_date, end_date)
      where("update_date >= ? AND update_date <= ?", start_date, end_date )
    end

    def categorical(*columns)
      @categorical_columns = columns.to_a
    end

    def categorical_columns
      @categorical_columns ||= []
    end

    def categorical_values
      Hash[@categorical_columns.map{ |col| [col, pluck(col).uniq.compact.sort] }]
    end

    def custom_attribute_mappings
      Hash[attribute_names.zip(custom_attribute_names)]
    end

    def custom_attribute(new_attribute, old_attribute)
      alias_attribute new_attribute, old_attribute
      custom_attribute_names.map! { |x| x == old_attribute.to_s ? new_attribute.to_s : x }
    end

    def custom_attribute_names
      @custom_attribute_names ||= attribute_names.dup
    end

    def set_integer_columns(*args)
      connection.set_type_for_columns(table_name,:integer,*args)
    end

    def to_csv
      CSV.generate(headers: true) do |csv|
        csv << custom_attribute_names
        all.each do |row|
          csv << row.custom_attributes.values
        end
      end
    end

  end

end
