require 'report'

class A1
  include Report
  table 'Hello' do
    body do
      row 'World'
    end
  end
end

describe Report do
  describe '#report_paths' do
    it "writes each table to a CSV" do
      require 'csv'
      table1 = CSV.read A1.new.csv.paths.first
      table1[0][0].should == 'World'
    end
  end
end
