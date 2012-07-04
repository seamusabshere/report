class Report
  class Body
    class Column
      attr_reader :body
      attr_reader :name
      attr_reader :method_id
      attr_reader :blk
      attr_reader :faded
      attr_reader :row_options
      def initialize(*args, &blk)
        if block_given?
          @blk = blk
        end
        @body = args.shift
        @name = args.shift
        options = args.extract_options!
        @method_id = options.delete(:method_id) || args.shift
        @faded = options.delete(:faded)
        @row_options = options
      end
      def read(report, obj)
        if blk
          case blk.arity
          when 0
            obj.instance_eval(&blk)
          when 2
            blk.call report, obj
          else
            raise "column block should have 0 or 2 arguments"
          end
        elsif method_id
          obj.send method_id
        elsif from_name = guesses.detect { |m| obj.respond_to?(m) }
          obj.send from_name
        else
          raise "#{obj.inspect} does not respond to any of #{guesses.inspect}"
        end
      end
      def read_with_options(report, obj)
        v = read report, obj
        f = case faded
        when Symbol
          obj.send faded
        else
          faded
        end
        { :value => v, :faded => f }.merge row_options
      end
      private
      def guesses
        [ name, name.underscore.gsub(/\W/, '_') ]
      end
    end
  end
end
