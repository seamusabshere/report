class Report
  class Csv
    class Table < Struct.new(:parent, :table)
      include Report::Utils
      def path
        return @path if defined?(@path)
        tmp_path = tmp_path(:hint => table.name, :extname => '.csv')
        File.open(tmp_path, 'wb') do |f|
          if table._head
            table._head.each(parent.report) do |row|
              f.write row.to_a.to_csv
            end
            f.write [].to_csv
          end
          if table._body
            f.write table._body.columns.map(&:name).to_csv
            table._body.each(parent.report) do |row|
              f.write row.to_a.to_csv
            end
          end
        end
        @path = tmp_path
      end
      def cleanup
        safe_delete @path if @path
      end
    end
  end
end
