module Report
  class Csv
    class Table
      class Row < Struct.new(:parent)
        def write_to(f)
          f.write parent.to_a.to_csv
        end
      end
    end
  end
end
