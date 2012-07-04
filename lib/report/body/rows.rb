class Report
  class Body
    class Rows
      attr_reader :body
      attr_accessor :method_id
      attr_accessor :args
      def initialize(*args)
        @body = args.shift
        @method_id = args.shift
        if args.last.is_a?(Array)
          @args = args.last
        end
      end
      def each(report, &blk)
        (args ? report.send(method_id, *args) : report.send(method_id)).each do |obj|
          blk.call obj
        end
      end
    end
  end
end
