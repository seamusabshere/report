module Report
  module ClassMethods
    def table(table_name, &blk)
      Report.tables(name) << Table.new(table_name, &blk)
    end

    def format(format_name, &blk)
      Report.formats(name)[format_name] = blk
    end
  end
end
