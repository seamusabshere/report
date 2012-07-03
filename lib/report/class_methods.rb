module Report
  module ClassMethods
    def table(name, &blk)
      Report.tables(self.name) << Table.new(name, &blk)
    end
  end
end
