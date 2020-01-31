module OracleUtility

  ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter.class_eval do
    self.emulate_booleans_from_strings = true
  end

  ActiveRecord::ConnectionAdapters::OracleEnhanced::DatabaseStatements.module_eval do
    def sql_for_insert(sql, pk, id_value, sequence_name, binds)
      [sql, binds]
    end
  end

end
