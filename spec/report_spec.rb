# -*- encoding: utf-8 -*-
# 日
require 'report'

class A1
  include Report
  table 'Hello' do
    head do
      row 'World'
    end
  end
end
class A2
  Translation = Struct.new(:language, :translation)
  include Report
  table 'How to say hello' do
    body do
      rows :translations
      column 'Language'
      column 'Translation'
    end
  end
  def translations
    [
      Translation.new('English', 'Hello'),
      Translation.new('Russian', 'Здравствуйте')
    ]
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
  end
end
