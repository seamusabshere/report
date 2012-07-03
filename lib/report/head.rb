module Report
  class Head
    attr_reader :table
    def initialize(table, &blk)
      @table = table
      @rows = []
      instance_eval(&blk)
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
