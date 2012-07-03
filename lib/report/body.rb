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
    def rows(method_id = nil)
      @rows = Rows.new self, method_id
    end
    def column(name)
      @columns << Column.new(self, name)
    end
    def each(report)
      yield columns.map(&:name)
      @rows.each(report) do |obj|
        yield Row.new(self, obj)
      end
    end
  end
end
