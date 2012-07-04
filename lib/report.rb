require 'active_support/core_ext'

require 'report/version'
require 'report/utils'

require 'report/table'
require 'report/filename'
require 'report/formatter'
require 'report/template'
require 'report/head'
require 'report/body'
require 'report/xlsx'
require 'report/csv'
require 'report/pdf'

class Report
  class << self
    attr_accessor :tables
    attr_accessor :pdf_format
    attr_accessor :xlsx_format

    def table(table_name, &blk)
      tables << Table.new(table_name, &blk)
    end

    def format_pdf(hsh)
      self.pdf_format = hsh
    end

    def format_xlsx(&blk)
      self.xlsx_format = blk
    end

    def inherited(klass)
      klass.tables = []
      klass.pdf_format = {}
    end
  end

  def tables
    self.class.tables
  end

  def pdf_format
    self.class.pdf_format
  end

  def xlsx_format
    self.class.xlsx_format
  end

  def csv
    @csv ||= Csv.new self
  end

  def xlsx
    @xlsx ||= Xlsx.new self
  end

  def pdf
    @pdf ||= Pdf.new self
  end
end
