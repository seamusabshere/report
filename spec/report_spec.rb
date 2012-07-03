# -*- encoding: utf-8 -*-
# 日
require 'report'

class Translation < Struct.new(:language, :translation)
  class << self
    def all
      [
        Translation.new('English', 'Hello'),
        Translation.new('Russian', 'Здравствуйте')
      ]
    end
  end
end

class A1
  include Report
  table 'Hello' do
    head do
      row 'World'
    end
  end
end
class A2
  include Report
  table 'How to say hello' do
    body do
      rows :translations
      column 'Language'
      column 'Translation'
    end
  end
  def translations
    Translation.all
  end
end
class A3
  include Report
  table 'Translations' do
    head do
      row 'Report type', :description
    end
    body do
      rows :translations
      column 'Language'
      column 'Translation'
    end
  end
  def description
    "How to say hello in a few languages!"
  end
  def translations
    Translation.all
  end
end

describe Report do
  describe '#csv' do
    it "writes each table to a separate file" do
      hello = ::CSV.read A1.new.csv.paths.first
      hello[0][0].should == 'World'
    end
    it "constructs a body out of rows and columns" do
      how_to_say_hello = ::CSV.read A2.new.csv.paths.first, :headers => :first_row
      how_to_say_hello[0]['Language'].should == 'English'
      how_to_say_hello[0]['Translation'].should == 'Hello'
      how_to_say_hello[1]['Language'].should == 'Russian'
      how_to_say_hello[1]['Translation'].should == 'Здравствуйте'
    end
    it "puts a blank row between head and body" do
      transl_with_head = ::CSV.read A3.new.csv.paths.first, :headers => false
      transl_with_head[0][0].should == "Report type"
      transl_with_head[0][1].should == "How to say hello in a few languages!"
      transl_with_head[4][0].should == "Russian"
      transl_with_head[4][1].should == 'Здравствуйте'
    end
  end
end
