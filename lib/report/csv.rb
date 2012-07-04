require 'csv'

require 'report/csv/table'

class Report
  class Csv
    attr_reader :report
    def initialize(report)
      @report = report
    end
    def paths
      tables.map { |table| table.path }
    end
    private
    def tables
      @tables ||= report.tables.map do |report_table|
        Csv::Table.new self, report_table
      end
    end
  end
end
