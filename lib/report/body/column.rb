module Report
  class Body
    class Column
      attr_reader :body
      attr_reader :name
      def initialize(body, name)
        @body = body
        @name = name
      end
      def read(obj)
        method_id = candidates.detect do |m|
          obj.respond_to?(m)
        end
        unless method_id
          raise "#{obj.inspect} does not respond to any of #{candidates.inspect}"
        end
        obj.send method_id
      end
      private
      def candidates
        [ name, name.underscore.gsub(/\W/, '_') ]
      end
    end
  end
end
