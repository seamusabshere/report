module Report
  class Csv
    class Table < Struct.new(:parent, :table)
      include Report::Utils
      def path
        return @path if defined?(@path)
        tmp_path = tmp_path table.name
        File.open(tmp_path, 'wb') do |f|
          table.each(parent.report) do |row|
            Csv::Table::Row.new(row).write_to(f)
          end
        end
        @path = tmp_path
      end
    end
  end
end

require 'report/csv/table/row'
