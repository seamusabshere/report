class Report
  class Body
    class Row
      attr_reader :body
      attr_reader :obj
      def initialize(body, obj)
        @body = body
        @obj = obj
      end
      def to_a
        body.columns.map { |column| column.read(obj) }
      end
      def to_hash
        body.columns.map do |column|
          { :value => column.read(obj) }.merge column.row_options
        end
      end
    end
  end
end
