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
    attr_accessor :formats

    def table(table_name, &blk)
      @tables << Table.new(table_name, &blk)
    end

    def format(format_name, &blk)
      @formats[format_name] = blk
    end

    def inherited(klass)
      klass.tables = []
      klass.formats = {}
    end
  end

  def tables
    self.class.tables
  end

  def formats
    self.class.formats
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
