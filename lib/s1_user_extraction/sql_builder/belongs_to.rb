module S1UserExtraction
  module SQLBuilder
    class BelongsTo

      attr_reader :query

      SQL_QUERY = 'SELECT %{col_name} FROM %{table_name} WHERE id in ${%{id_name}}'

      def initialize(table_name, col_name, id_name)
        @query = build_query(table_name, col_name, id_name)
      end

      def build_query(table_name, col_name, id_name)
        format(SQL_QUERY, {table_name: table_name, col_name: col_name, id_name: id_name})
      end

    end
  end
end
