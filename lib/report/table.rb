module Report
  class Table
    attr_reader :name
    def initialize(name, &blk)
      @name = name
      instance_eval(&blk)
    end
    def body(&blk)
      @body ||= Body.new(self, &blk)
    end
    def head(&blk)
      @head ||= Head.new(self, &blk)
    end
    def each(report)
      @head.each do |row|
        yield row
      end if defined?(@head)
      @body.each(report) do |row|
        yield row
      end if defined?(@body)
    end
  end
end
