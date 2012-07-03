require 'fileutils'

module Report
  class Xlsx
    include Utils
    attr_reader :report
    def initialize(report)
      @report = report
    end
    def path
      return @path if defined?(@path)
      require 'xlsx_writer'
      tmp_path = tmp_path(:extname => '.xlsx')
      workbook = XlsxWriter::Document.new
      report.tables.each do |table|
        sheet = workbook.add_sheet table.name
        table.each(report) do |row|
          sheet.add_row row.to_a
        end
      end
      FileUtils.mv workbook.path, tmp_path
      workbook.cleanup
      @path = tmp_path
    end
  end
end
