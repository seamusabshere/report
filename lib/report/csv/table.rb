module Report
  class Csv
    class Table < Struct.new(:parent, :table)
      include Report::Utils
      def path
        return @path if defined?(@path)
        tmp_path = tmp_path(:hint => table.name, :extname => '.csv')
        File.open(tmp_path, 'wb') do |f|
          table.each(parent.report) do |row|
            f.write row.to_a.to_csv
          end
        end
        @path = tmp_path
      end
    end
  end
end
