require 'fileutils'

module Report
  class Pdf
    include Utils
    attr_reader :report
    def initialize(report)
      @report = report
    end
    def path
      return @path if defined?(@path)
      require 'prawn'
      tmp_path = tmp_path(:extname => '.pdf')
      Prawn::Document.generate(tmp_path, document_options) do |pdf|
        
        pdf.font_families.update('MyDejaVuSansMono' => {
          :normal      => File.expand_path('../pdf/DejaVuSansMono.ttf', __FILE__),
          :italic      => File.expand_path('../pdf/DejaVuSansMono-Oblique.ttf', __FILE__),
          :bold        => File.expand_path('../pdf/DejaVuSansMono-Bold.ttf', __FILE__),
          :bold_italic => File.expand_path('../pdf/DejaVuSansMono-BoldOblique.ttf', __FILE__),
        })
        pdf.font 'MyDejaVuSansMono'

        report.tables.each do |table|
          t = []
          table.each_head(report) { |row| t << row.to_a }
          pdf.table t if t.length > 0

          pdf.move_down 20
          pdf.text table.name, :style => :bold
          pdf.move_down 10

          t = []
          table.each_body(report) { |row| t << row.to_a }
          pdf.table(t, body_table_options) if t.length > 0
        end

        pdf.number_pages "Page <page> of <total>", :at => [648, -2], :width => 100, :size => 10
      end
      
      if stamp_path
        require 'posix/spawn'
        POSIX::Spawn::Child.new 'pdftk', tmp_path, 'stamp', stamp_path, 'output', "#{tmp_path}.stamped"
        FileUtils.mv "#{tmp_path}.stamped", tmp_path
      end

      @path = tmp_path
    end
    private
    def document_options
      {
        :top_margin => 118,
        :right_margin => 36,
        :bottom_margin => 72,
        :left_margin => 36,
        :page_layout => :landscape,
      }
    end
    def body_table_options
      {:width => (10*72), :header => true}
    end
    def stamp_path
      nil
    end
  end
end
