class Report
  class Table
    attr_reader :name
    def initialize(name, &blk)
      @name = name
      instance_eval(&blk)
    end
    def body(&blk)
      @body = Body.new(self, &blk)
    end
    def head(&blk)
      @head = Head.new(self, &blk)
    end
    def each(report)
      if defined?(@head)
        @head.each(report) do |row|
          yield row
        end
        yield [] # blank row
      end
      @body.each(report) do |row|
        yield row
      end if defined?(@body)
    end
    def each_head(report)
      @head.each(report) do |row|
        yield row
      end if defined?(@head)
    end
    def each_body(report)
      @body.each(report) do |row|
        yield row
      end if defined?(@body)
    end
  end
end
