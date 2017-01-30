module S1UserExtraction
  module SQLBuilder
    class Builder

      SQL_QUERY = 'SELECT * INTO OUTFILE %{outfile}-%{table_name} ' \
                  'FROM %{table_name} WHERE %{id_column} = %{id_value}'

      def build_query(table_name, id_column, id_value)
        format(SQL_QUERY, {outfile: 'outfile', table_name: table_name, id_column: id_column, id_value: id_value})
      end

    end
  end
end
