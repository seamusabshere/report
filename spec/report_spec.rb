# -*- encoding: utf-8 -*-
# 日
require 'report'

require 'remote_table'
require 'unix_utils'
require 'posix/spawn'

class Translation < Struct.new(:language, :content)
  class << self
    def all
      [ new('English', 'Hello'), new('Russian', 'Здравствуйте') ]
    end
  end
  def backward
    content.reverse
  end
end

class A1 < Report
  table 'Hello' do
    head do
      row 'World'
    end
  end
end
class A2 < Report
  table 'How to say hello' do
    body do
      rows :translations
      column 'Language'
      column 'Content'
    end
  end
  def translations
    Translation.all
  end
end
class A3 < Report
  table 'Translations' do
    head do
      row 'Report type', :description
    end
    body do
      rows :translations
      column 'Language'
      column 'Content'
    end
  end
  def description
    "How to say hello in a few languages!"
  end
  def translations
    Translation.all
  end
end
class A4 < Report
  table 'Translations and more' do
    body do
      rows :translations
      column 'Language'
      column 'Forward', :content
      column 'Backward'
    end
  end
  def translations
    Translation.all
  end
end
class A5 < Report
  table 'InEnglish' do
    body do
      rows :translations, ['English']
      column 'Language'
      column 'Content'
    end
  end
  table 'InRussian' do
    body do
      rows :translations, ['Russian']
      column 'Language'
      column 'Content'
    end
  end
  def translations(language)
    Translation.all.select { |t| t.language == language }
  end
end
class A6 < Report
  table 'Translations and more, again' do
    body do
      rows :translations
      column 'Language'
      column('Forward') { content }
      column('Backward') { content.reverse }
    end
  end
  def translations
    Translation.all
  end
end
class A7 < Report
  format_xlsx do |xlsx|
    xlsx.header.right.contents = 'Corporate Reporting Program'
    xlsx.page_setup.top = 1.5
    xlsx.page_setup.header = 0
    xlsx.page_setup.footer = 0
  end
  table 'Hello' do
    head do
      row 'World'
    end
  end
end
class A8 < Report
  table 'A8' do
    body do
      rows :translations
      column 'Language'
      column('ClassForward') { |report, translation| [report.class.name, translation.content].join }
      column('ClassBackward') { |report, translation| [report.class.name.reverse, translation.content.reverse].join }
    end
  end
  def translations
    Translation.all
  end
end
class A9 < Report
  table 'MemorySafe' do
    body do
      rows :translations
      column 'Language'
      column 'Content'
    end
  end
  def translations
    Translation.all.each do |translation|
      yield translation
    end
  end
end
class Numero < Struct.new(:d_e_c_i_m_a_l, :m_o_n_e_y)
  class << self
    def all
      [ new(9.9, 2.5) ]
    end
  end
  def always_true
    true
  end
  def always_false
    false
  end
end
class B1 < Report
  table 'Numbers' do
    body do
      rows :numbers
      column 'd_e_c_i_m_a_l', :type => :Decimal, :faded => :always_true
      column 'm_o_n_e_y', :type => :Currency, :faded => :always_false
    end
  end
  def numbers
    Numero.all
  end
end
class B2 < Report
  format_pdf(
    :document => { :page_layout => :landscape },
    :head => {:width => (10*72)},
    :body => {:width => (10*72), :header => true},
    :font => {
      :normal => File.expand_path('../../lib/report/pdf/DejaVuSansMono-Oblique.ttf', __FILE__),
    },
    :number_pages => ["Page <page> of <total>", {:at => [648, -2], :width => 100, :size => 10}],
    :stamp => File.expand_path("../stamp.pdf", __FILE__)
  )
  table 'Numbers' do
    body do
      rows :numbers
      column 'd_e_c_i_m_a_l', :type => :Decimal, :faded => true
      column 'm_o_n_e_y', :type => :Currency
    end
  end
  def numbers
    Numero.all
  end
end
class Witness < Struct.new(:really_saw_it)
  class << self
    def all
      [ new(true), new(false) ]
    end
  end
  def did_you_really_see_it?
    !!really_saw_it
  end
end
class C1 < Report
  table 'C1' do
    body do
      rows :witnesses
      column 'Did you really see it?'
    end
  end
  def witnesses
    Witness.all
  end
end

describe Report do
  it "cleans up if asked" do
    r = A1.new
    mess = []
    mess += r.csv.paths
    mess << r.xlsx.path
    mess << r.pdf.path
    mess.each do |path|
      File.exist?(path).should == true
    end
    r.cleanup
    mess.each do |path|
      File.exist?(path).should == false
    end
  end

  describe '#csv' do
    it "writes each table to a separate file" do
      hello = ::CSV.read A1.new.csv.paths.first
      hello[0][0].should == 'World'
    end
    it "constructs a body out of rows and columns" do
      how_to_say_hello = ::CSV.read A2.new.csv.paths.first, :headers => :first_row
      how_to_say_hello[0]['Language'].should == 'English'
      how_to_say_hello[0]['Content'].should == 'Hello'
      how_to_say_hello[1]['Language'].should == 'Russian'
      how_to_say_hello[1]['Content'].should == 'Здравствуйте'
    end
    it "puts a blank row between head and body" do
      transl_with_head = ::CSV.read A3.new.csv.paths.first, :headers => false
      transl_with_head[0][0].should == "Report type"
      transl_with_head[0][1].should == "How to say hello in a few languages!"
      transl_with_head[4][0].should == "Russian"
      transl_with_head[4][1].should == 'Здравствуйте'
    end
    it "passes arguments on columns" do
      t = ::CSV.read A4.new.csv.paths.first, :headers => :first_row
      en = t[0]
      ru = t[1]
      en['Language'].should == 'English'
      en['Forward'].should == 'Hello'
      en['Backward'].should == 'Hello'.reverse
      ru['Language'].should == 'Russian'
      ru['Forward'].should == 'Здравствуйте'
      ru['Backward'].should == 'Здравствуйте'.reverse
    end
    it "passes arguments on rows" do
      en_path, ru_path = A5.new.csv.paths
      en = ::CSV.read en_path, :headers => :first_row
      en.length.should == 1
      en[0]['Language'].should == 'English'
      en[0]['Content'].should == 'Hello'
      ru = ::CSV.read ru_path, :headers => :first_row
      ru.length.should == 1
      ru[0]['Language'].should == 'Russian'
      ru[0]['Content'].should == 'Здравствуйте'
    end
    it "instance-evals column blocks against row objects if arity is 0" do
      t = ::CSV.read A6.new.csv.paths.first, :headers => :first_row
      en = t[0]
      ru = t[1]
      en['Language'].should == 'English'
      en['Forward'].should == 'Hello'
      en['Backward'].should == 'Hello'.reverse
      ru['Language'].should == 'Russian'
      ru['Forward'].should == 'Здравствуйте'
      ru['Backward'].should == 'Здравствуйте'.reverse
    end
    it "calls column blocks with |report, row_obj| if arity == 2" do
      t = ::CSV.read A8.new.csv.paths.first, :headers => :first_row
      en = t[0]
      ru = t[1]
      en['Language'].should == 'English'
      en['ClassForward'].should == 'A8Hello'
      en['ClassBackward'].should == ['A8'.reverse, 'Hello'.reverse].join
      ru['Language'].should == 'Russian'
      ru['ClassForward'].should == 'A8Здравствуйте'
      ru['ClassBackward'].should == ['A8'.reverse, 'Здравствуйте'.reverse].join
    end
    it "can have row objects yield to it one by one" do
      how_to_say_hello = ::CSV.read A9.new.csv.paths.first, :headers => :first_row
      how_to_say_hello[0]['Language'].should == 'English'
      how_to_say_hello[0]['Content'].should == 'Hello'
      how_to_say_hello[1]['Language'].should == 'Russian'
      how_to_say_hello[1]['Content'].should == 'Здравствуйте'
    end
    it "treats ? and ! as valid method characters" do
      t = ::CSV.read C1.new.csv.paths.first, :headers => :first_row
      t[0]['Did you really see it?'].should == 'true'
      t[1]['Did you really see it?'].should == 'false'
    end
  end

  describe '#xlsx' do
    it "writes all tables to the same file" do
      hello = RemoteTable.new A1.new.xlsx.path, :headers => false
      hello[0][0].should == 'World'
    end
    it "constructs a body out of rows and columns" do
      how_to_say_hello = RemoteTable.new A2.new.xlsx.path, :headers => :first_row
      how_to_say_hello[0]['Language'].should == 'English'
      how_to_say_hello[0]['Content'].should == 'Hello'
      how_to_say_hello[1]['Language'].should == 'Russian'
      how_to_say_hello[1]['Content'].should == 'Здравствуйте'
    end
    it "puts a blank row between head and body" do
      transl_with_head = RemoteTable.new A3.new.xlsx.path, :headers => false, :keep_blank_rows => true
      transl_with_head[0][0].should == "Report type"
      transl_with_head[0][1].should == "How to say hello in a few languages!"
      transl_with_head[4][0].should == "Russian"
      transl_with_head[4][1].should == 'Здравствуйте'
    end
    it "passes arguments on columns" do
      t = RemoteTable.new A4.new.xlsx.path, :headers => :first_row
      en = t[0]
      ru = t[1]
      en['Language'].should == 'English'
      en['Forward'].should == 'Hello'
      en['Backward'].should == 'Hello'.reverse
      ru['Language'].should == 'Russian'
      ru['Forward'].should == 'Здравствуйте'
      ru['Backward'].should == 'Здравствуйте'.reverse
    end
    it "passes arguments on rows" do
      path = A5.new.xlsx.path
      en = RemoteTable.new(path, :headers => :first_row, :sheet => 'InEnglish').to_a
      en.length.should == 1
      en[0]['Language'].should == 'English'
      en[0]['Content'].should == 'Hello'
      ru = RemoteTable.new(path, :headers => :first_row, :sheet => 'InRussian').to_a
      ru.length.should == 1
      ru[0]['Language'].should == 'Russian'
      ru[0]['Content'].should == 'Здравствуйте'
    end
    it "instance-evals column blocks against row objects" do
      t = RemoteTable.new A6.new.xlsx.path, :headers => :first_row
      en = t[0]
      ru = t[1]
      en['Language'].should == 'English'
      en['Forward'].should == 'Hello'
      en['Backward'].should == 'Hello'.reverse
      ru['Language'].should == 'Russian'
      ru['Forward'].should == 'Здравствуйте'
      ru['Backward'].should == 'Здравствуйте'.reverse
    end
    it "can have row objects yield to it one by one" do
      how_to_say_hello = RemoteTable.new A9.new.xlsx.path, :headers => :first_row
      how_to_say_hello[0]['Language'].should == 'English'
      how_to_say_hello[0]['Content'].should == 'Hello'
      how_to_say_hello[1]['Language'].should == 'Russian'
      how_to_say_hello[1]['Content'].should == 'Здравствуйте'
    end
    it "accepts a formatter that works on the raw XlsxWriter::Document" do
      path = A7.new.xlsx.path
      dir = UnixUtils.unzip path
      File.read("#{dir}/xl/worksheets/sheet1.xml").should include('Corporate Reporting Program')
      FileUtils.rm_f path
    end
    it "allows setting cell options" do
      path = B1.new.xlsx.path
      dir = UnixUtils.unzip path
      xml = File.read("#{dir}/xl/worksheets/sheet1.xml")
      xml.should match(/s="2".*2.5/) # Currency
      xml.should match(/s="9".*9.9/) # faded Decimal
      FileUtils.rm_f path
      FileUtils.rm_rf dir
    end
    it "automatically adds an autofilter" do
      path = A2.new.xlsx.path
      dir = UnixUtils.unzip path
      xml = File.read("#{dir}/xl/worksheets/sheet1.xml")
      xml.should include('autoFilter ref="A1:B1')
      FileUtils.rm_f path
      FileUtils.rm_rf dir
    end
    it "treats ? and ! as valid method characters" do
      path = C1.new.xlsx.path
      t = RemoteTable.new path, :headers => :first_row
      t[0]['Did you really see it?'].should == 'TRUE'
      t[1]['Did you really see it?'].should == 'FALSE'
    end
  end

  describe '#pdf' do
    it "writes all tables to the same file" do
      hello = A1.new.pdf.path
      child = POSIX::Spawn::Child.new('pdftotext', hello, '-')
      stdout_utf8 = child.out.force_encoding('UTF-8')
      stdout_utf8.should include('World')
    end
    it "constructs a body out of head rows and body rows and column names" do
      how_to_say_hello = A2.new.pdf.path
      child = POSIX::Spawn::Child.new('pdftotext', how_to_say_hello, '-')
      stdout_utf8 = child.out.force_encoding('UTF-8')
      stdout_utf8.should include('Language')
      stdout_utf8.should include('Content')
      stdout_utf8.should include('English')
      stdout_utf8.should include('Hello')
      stdout_utf8.should include('Russian')
      stdout_utf8.should include('Здравствуйте')
    end
    it "puts a blank row between head and body" do
      transl_with_head = A3.new.pdf.path
      child = POSIX::Spawn::Child.new('pdftotext', transl_with_head, '-')
      stdout_utf8 = child.out.force_encoding('UTF-8')
      stdout_utf8.should include("Report type")
      stdout_utf8.should include("How to say hello in a few languages!")
      stdout_utf8.should include('Russian')
      stdout_utf8.should include('Здравствуйте')
    end
    it "passes arguments on columns" do
      t = A4.new.pdf.path
      child = POSIX::Spawn::Child.new('pdftotext', t, '-')
      stdout_utf8 = child.out.force_encoding('UTF-8')
      stdout_utf8.should include('English')
      stdout_utf8.should include('Hello')
      stdout_utf8.should include('Hello'.reverse)
      stdout_utf8.should include('Russian')
      stdout_utf8.should include('Здравствуйте')
      stdout_utf8.should include('Здравствуйте'.reverse)
    end
    it "passes arguments on rows" do
      path = A5.new.pdf.path
      child = POSIX::Spawn::Child.new('pdftotext', path, '-')
      stdout_utf8 = child.out.force_encoding('UTF-8')
      stdout_utf8.should include('InEnglish')
      stdout_utf8.should include('InRussian')
      stdout_utf8.should include('English')
      stdout_utf8.should include('Hello')
      stdout_utf8.should include('Russian')
      stdout_utf8.should include('Здравствуйте')
    end
    it "instance-evals column blocks against row objects" do
      t = A6.new.pdf.path
      child = POSIX::Spawn::Child.new('pdftotext', t, '-')
      stdout_utf8 = child.out.force_encoding('UTF-8')
      stdout_utf8.should include('English')
      stdout_utf8.should include('Hello')
      stdout_utf8.should include('Hello'.reverse)
      stdout_utf8.should include('Russian')
      stdout_utf8.should include('Здравствуйте')
      stdout_utf8.should include('Здравствуйте'.reverse)
    end
    it "can have row objects yield to it one by one" do
      t = A9.new.pdf.path
      child = POSIX::Spawn::Child.new('pdftotext', t, '-')
      stdout_utf8 = child.out.force_encoding('UTF-8')
      stdout_utf8.should include('English')
      stdout_utf8.should include('Hello')
      stdout_utf8.should include('Russian')
      stdout_utf8.should include('Здравствуйте')
    end
    it "accepts pdf formatting options, including the ability to stamp with pdftk" do
      path = B2.new.pdf.path
      child = POSIX::Spawn::Child.new('pdftotext', path, '-')
      stdout_utf8 = child.out.force_encoding('UTF-8')
      stdout_utf8.should include('Firefox')
    end
    it "treats ? and ! as valid method characters" do
      t = C1.new.pdf.path
      child = POSIX::Spawn::Child.new('pdftotext', t, '-')
      stdout_utf8 = child.out.force_encoding('UTF-8')
      stdout_utf8.should include('true')
      stdout_utf8.should include('false')
    end
  end
end
