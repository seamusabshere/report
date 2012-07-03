module Report
  class Table
    attr_reader :name
    def initialize(name, &blk)
      @name = name
      @head = Head.new self
      @body = Body.new self
      instance_eval(&blk)
    end
    def body(&blk)
      @body.instance_eval(&blk)
    end
    def head(&blk)
      @head.instance_eval(&blk)
    end
    def each_row
      @head.each do |row|
        yield row
      end
      @body.each do |row|
        yield row
      end
    end
  end
end
