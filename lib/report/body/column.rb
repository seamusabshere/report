module Report
  class Body
    class Column
      attr_reader :body
      attr_reader :name
      attr_reader :method_id
      attr_reader :proc
      def initialize(*args, &proc)
        if block_given?
          @proc = proc
        end
        @body = args.shift
        @name = args.shift
        options = args.extract_options!
        @method_id = options[:method_id] || args.shift
      end
      def read(obj)
        if @proc
          return obj.instance_eval(&@proc)
        end
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
        if method_id
          [ method_id ]
        else
          [ name, name.underscore.gsub(/\W/, '_') ]
        end
      end
    end
  end
end
