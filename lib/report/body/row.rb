class Report
  class Body
    class Row
      attr_reader :body
      attr_reader :obj
      attr_reader :report
      def initialize(body, report, obj)
        @body = body
        @report = report
        @obj = obj
      end
      def to_a
        body.columns.map { |column| column.read(report, obj) }
      end
      def to_hash
        body.columns.map do |column|
          column.read_with_options report, obj
        end
      end
    end
  end
end
