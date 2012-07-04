require 'report/body/column'
require 'report/body/row'
require 'report/body/rows'

class Report
  class Body
    attr_reader :table
    attr_reader :columns
    def initialize(table)
      @table = table
      @columns = []
    end
    def rows(*args)
      @rows = Rows.new(*([self]+args))
    end
    def column(*args, &blk)
      @columns << Column.new(*([self]+args), &blk)
    end
    def each(report)
      @rows.each(report) do |obj|
        yield Row.new(self, report, obj)
      end
    end
    def to_a(report)
      a = []
      each(report) { |row| a << row.to_a }
      a
    end
  end
end
