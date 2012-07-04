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
      Prawn::Document.generate(tmp_path) do |pdf|
        
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
          pdf.table t if t.length > 0

        end
      end
      @path = tmp_path
    end
  end
end
