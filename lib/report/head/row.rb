module Report
  class Head
    class Row
      attr_reader :head
      attr_reader :cells
      def initialize(head, cells)
        @head = head
        @cells = cells
      end
      def read(report)
        cells.map do |cell|
          case cell
          when String
            cell
          when Symbol
            unless report.respond_to?(cell)
              raise "#{report.inspect} doesn't respond to #{cell.inspect}"
            end
            report.send cell
          else
            raise "must pass String or Symbol to head row"
          end
        end
      end
    end
  end
end
