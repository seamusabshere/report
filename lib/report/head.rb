class Report
  class Head
    attr_reader :table
    def initialize(table)
      @table = table
      @rows = []
    end
    def row(*cells)
      @rows << cells
    end
    def each(report)
      @rows.each do |row|
        actual = row.map do |cell|
          case cell
          when String
            cell
          when Symbol
            unless report.respond_to?(cell)
              raise "#{report.inspect} doesn't respond to #{cell.inspect}"
            end
            report.send cell
          else
            raise "must pass String or Symbol to head row"
          end
        end
        yield actual
      end
    end
    def to_a(report)
      a = []
      each(report) { |row| a << row.to_a }
      a
    end
  end
end
