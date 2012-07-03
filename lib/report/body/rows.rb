module Report
  class Body
    class Rows
      attr_reader :body
      attr_accessor :method_id
      def initialize(body, method_id)
        @body = body
        @method_id = method_id
      end
      def each(report, &blk)
        report.send(method_id).each do |obj|
          blk.call obj
        end
      end
    end
  end
end
