require 'active_support/core_ext'

require 'report/version'
require 'report/utils'

require 'report/class_methods'
require 'report/table'
require 'report/filename'
require 'report/formatter'
require 'report/template'
require 'report/head'
require 'report/body'
require 'report/xlsx'
require 'report/csv'
require 'report/pdf'

module Report
  def self.included(klass)
    klass.extend ClassMethods
  end

  def self.tables(class_name)
    @tables ||= {}
    @tables[class_name] ||= []
  end

  def self.formats(class_name)
    @formats ||= {}
    @formats[class_name] ||= {}
  end

  def tables
    Report.tables self.class.name
  end

  def formats
    Report.formats self.class.name
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
