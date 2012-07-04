require 'report/head/row'

class Report
  class Head
    attr_reader :table
    def initialize(table)
      @table = table
      @rows = []
    end
    def row(*cells)
      @rows << Row.new(self, cells)
    end
    def each(report)
      @rows.each do |row|
        yield row.read(report)
      end
    end
    def to_a(report)
      a = []
      each(report) { |row| a << row.to_a }
      a
    end
  end
end
