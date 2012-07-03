require 'report/body/column'
require 'report/body/row'
require 'report/body/rows'

module Report
  class Body
    attr_reader :table
    attr_reader :columns
    def initialize(table, &blk)
      @table = table
      @columns = []
      instance_eval(&blk)
    end
    def rows(*args)
      @rows = Rows.new(*([self]+args))
    end
    def column(*args, &blk)
      @columns << Column.new(*([self]+args), &blk)
    end
    def each(report)
      yield columns.map(&:name)
      @rows.each(report) do |obj|
        yield Row.new(self, obj)
      end
    end
  end
end
