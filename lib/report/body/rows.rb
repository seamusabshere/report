class Report
  class Body
    class Rows
      attr_reader :body
      attr_accessor :method_id
      attr_accessor :method_args
      def initialize(*args)
        @body = args.shift
        @method_id = args.shift
        if args.last.is_a?(Array)
          @method_args = args.last
        end
      end
      # TODO simplify this... am I missing something obvious?
      def each(report)
        block_taken = false
        if method_args
          enum = report.send(method_id, *method_args) do |obj|
            block_taken = true
            yield obj
          end
        else
          enum = report.send(method_id) do |obj|
            block_taken = true
            yield obj
          end
        end
        unless block_taken
          enum.each do |obj|
            yield obj
          end
        end
      end
    end
  end
end
