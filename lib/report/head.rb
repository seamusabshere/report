require 'report/head/row'

module Report
  class Head
    attr_reader :table
    def initialize(table, &blk)
      @table = table
      @rows = []
      instance_eval(&blk)
    end
    def row(*cells)
      @rows << Row.new(self, cells)
    end
    def each(report)
      @rows.each do |row|
        yield row.read(report)
      end
    end
  end
end
