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
          obj.instance_eval(&@proc)
        elsif method_id
          obj.send method_id
        elsif from_name = guesses.detect { |m| obj.respond_to?(m) }
          obj.send from_name
        else
          raise "#{obj.inspect} does not respond to any of #{guesses.inspect}"
        end
      end
      private
      def guesses
        [ name, name.underscore.gsub(/\W/, '_') ]
      end
    end
  end
end
