module Report
  class Row
    attr_reader :body
    attr_reader :obj
    def initialize(body, obj)
      @body = body
      @obj = obj
    end
    def to_a
      body.columns.map do |column|
        column.read obj
      end
    end
  end
end
