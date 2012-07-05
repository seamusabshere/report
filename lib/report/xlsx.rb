require 'fileutils'

class Report
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
      if f = report.class.xlsx_format
        f.call workbook
      end
      report.class.tables.each do |table|
        sheet = workbook.add_sheet table.name
        cursor = 1 # excel row numbers start at 1
        if table._head
          table._head.each(report) do |row|
            sheet.add_row row.to_a
            cursor += 1
          end
          sheet.add_row []
          cursor += 1
        end
        if table._body
          sheet.add_row table._body.columns.map(&:name)
          table._body.each(report) do |row|
            sheet.add_row row.to_hash
          end
          sheet.add_autofilter calculate_autofilter(table, cursor)
        end
      end
      FileUtils.mv workbook.path, tmp_path
      workbook.cleanup
      @path = tmp_path
    end

    def cleanup
      safe_delete @path if @path
    end

    private
    def calculate_autofilter(table, cursor)
      [ 'A', cursor, ':', XlsxWriter::Cell.excel_column_letter(table._body.columns.length-1), cursor ].join
    end
  end
end
