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
    def _head
      @head
    end
    def _body
      @body
    end
  end
end
