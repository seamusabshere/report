module Report
  class Csv
    class Table < Struct.new(:parent)
      include Report::Utils
      def path
        return @path if defined?(@path)
        tmp_path = tmp_path parent.name
        File.open(tmp_path, 'wb') do |f|
          parent.each_row do |row|
            Csv::Table::Row.new(row).write_to(f)
          end
        end
        @path = tmp_path
      end
    end
  end
end

require 'report/csv/table/row'
