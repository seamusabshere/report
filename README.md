# Report

DSL for creating clean CSV, XLSX, and PDF reports in Ruby.

Extracted from Brighter Planet's corporate reporting system.

## Usage

    class FleetReport < Report
      table 'Cars' do
        head do
          row 'Report type', :description
          row 'Batchfile', :batchfile
        end
        body do
          rows :vehicles, ['car']
          column 'Vehicle ID', :id
          column 'CO2 score', :carbon
          column 'CO2 units', 'kg'
          column 'Fuel grade'
          column 'Fuel volume'
          column 'Odometer'
          column 'City'
          column 'State'
          column 'Postal code', :zip_code
          column 'Country'
          column 'Methodology'
        end
      end

      table 'Trucks' do
        head do
          row 'Report type', :description
          row 'Batchfile', :batchfile
        end
        body do
          rows :vehicles, ['truck']
          column 'Vehicle ID', :id
          column 'CO2 score', :carbon
          column 'CO2 units', 'kg'
          column 'Fuel grade'
          column 'Fuel volume'
          column 'Odometer'
          column 'City'
          column 'State'
          column 'Postal code', :zip_code
          column 'Country'
          column 'Methodology'
        end
      end

      format_pdf(
        :document => { :page_layout => :landscape },
        :head => {:width => (10*72)},
        :body => {:width => (10*72), :header => true}
      )

      format_xlsx do |xlsx|
        xlsx.header.right.contents = 'Corporate Reporting Program'
        xlsx.page_setup.top = 1.5
        xlsx.page_setup.header = 0
        xlsx.page_setup.footer = 0
      end

      attr_reader :batchfile

      def initialize(batchfile)
        @batchfile = batchfile
      end

      def description
        'Fleet sustainability report'
      end

      def vehicles(type)
        @batchfile.vehicles.where(:type => type)
      end
    end

    b = Batchfile.first
    fr = FleetReport.new(b)
    fr.pdf.path
    fr.csv.paths # note one file per table
    fr.xlsx.path

## Real-world usage

<p><a href="http://brighterplanet.com"><img src="https://s3.amazonaws.com/static.brighterplanet.com/assets/logos/flush-left/inline/green/rasterized/brighter_planet-160-transparent.png" alt="Brighter Planet logo"/></a></p>

We use `report` for [corporate reporting products at Brighter Planet](http://brighterplanet.com/research) and in production at

* [Brighter Planet's impact estimate web service](http://impact.brighterplanet.com)
* [Brighter Planet's reference data web service](http://data.brighterplanet.com)

## Inspirations

### dynamicreports

http://dynamicreports.rubyforge.org/

    class OrdersReport < DynamicReports::Report
      title "Orders Report"
      subtitle "All orders recorded in database"
      columns :total, :created_at

      chart :total_vs_quantity do
        columns :total, :quantity
        label_column "created_at"
      end
    end

    # in the controller
    def orders
      @orders = Order.find(:all, :limit => 25)
      render :text => OrdersReport.on(@orders).to_html, :layout => "application"
    end

### reportbuilder

http://ruby-statsample.rubyforge.org/reportbuilder/

    require "reportbuilder"    
    rb=ReportBuilder.new do
      text("2")
      section(:name=>"Section 1") do
        table(:name=>"Table", :header=>%w{id name}) do
          row([1,"John"])
        end
      end
      preformatted("Another Text")
    end
    rb.name="Html output"
    puts rb.to_html

## Copyright

Copyright 2012 Brighter Planet, Inc.
