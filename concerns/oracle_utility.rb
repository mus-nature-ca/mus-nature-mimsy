module OracleUtility

  ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter.class_eval do
    self.emulate_booleans_from_strings = true

    def set_type_for_columns(table_name, column_type, *args)
      @@table_column_type ||= {}
      @@table_column_type[table_name] ||= {}
      args.each do |col|
        @@table_column_type[table_name][col.to_s.downcase] = column_type
      end
    end

  end

  ActiveRecord::ConnectionAdapters::OracleEnhanced::DatabaseStatements.module_eval do
    def sql_for_insert(sql, pk, id_value, sequence_name, binds)
      [sql, binds]
    end
  end

end
