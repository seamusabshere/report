# Report

DSL for creating CSV, XLSX, and PDF reports in Ruby.

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
