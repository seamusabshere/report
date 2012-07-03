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

module Report
  def self.included(klass)
    klass.extend ClassMethods
  end

  def self.tables(name)
    @tables ||= {}
    @tables[name] ||= []
  end

  def tables
    Report.tables(self.class.name)
  end

  def csv
    @csv ||= Csv.new self
  end
end
