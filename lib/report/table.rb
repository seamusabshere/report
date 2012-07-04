class Report
  class Table
    attr_reader :name
    def initialize(name)
      @name = name
    end
    def body(&blk)
      b = Body.new self
      b.instance_eval(&blk)
      @body = b
    end
    def head(&blk)
      h = Head.new self
      h.instance_eval(&blk)
      @head = h
    end
    def _head
      @head
    end
    def _body
      @body
    end
  end
end
