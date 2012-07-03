module Report
  class Body
    attr_reader :table
    def initialize(table)
      @table = table
      @rows = []
    end
    def row(*cells)
      @rows << cells
    end
    def each
      @rows.each do |row|
        yield row
      end
    end
  end
end
