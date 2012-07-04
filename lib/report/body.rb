require 'report/body/column'
require 'report/body/row'

class Report
  class Body
    attr_reader :table
    attr_reader :columns
    attr_reader :method_id
    attr_reader :method_args
    def initialize(table)
      @table = table
      @columns = []
    end
    def rows(*args)
      @method_id = args.shift
      if args.last.is_a?(Array)
        @method_args = args.last
      end
    end
    def column(*args, &blk)
      @columns << Column.new(*([self]+args), &blk)
    end
    def each(report)
      block_taken = false
      if method_args
        enum = report.send(method_id, *method_args) do |obj|
          block_taken = true
          yield Row.new(self, report, obj)
        end
      else
        enum = report.send(method_id) do |obj|
          block_taken = true
          yield Row.new(self, report, obj)
        end
      end
      unless block_taken
        enum.each do |obj|
          yield Row.new(self, report, obj)
        end
      end
    end
  end
end
