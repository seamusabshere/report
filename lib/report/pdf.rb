require 'fileutils'

class Report
  class Pdf
    DEFAULT_FONT = {
      :normal      => File.expand_path('../pdf/DejaVuSansMono.ttf', __FILE__),
      :italic      => File.expand_path('../pdf/DejaVuSansMono-Oblique.ttf', __FILE__),
      :bold        => File.expand_path('../pdf/DejaVuSansMono-Bold.ttf', __FILE__),
      :bold_italic => File.expand_path('../pdf/DejaVuSansMono-BoldOblique.ttf', __FILE__),
    }
    DEFAULT_DOCUMENT = {
      :top_margin => 72,
      :right_margin => 36,
      :bottom_margin => 72,
      :left_margin => 36,
      :page_layout => :landscape,
    }
    DEFAULT_HEAD = {}
    DEFAULT_BODY = {
      :width => (10*72),
      :header => true
    }
    DEFAULT_NUMBER_PAGES = [
      'Page <page> of <total>',
      {:at => [648, -2], :width => 100, :size => 10}
    ]

    include Utils

    attr_reader :report

    def initialize(report)
      @report = report
    end

    def path
      return @path if defined?(@path)
      require 'prawn'
      tmp_path = tmp_path(:extname => '.pdf')
      Prawn::Document.generate(tmp_path, document) do |pdf|
        
        pdf.font_families.update(font_name => font)
        pdf.font font_name, :size => 10

        first = true
        report.class.tables.each do |table|
          if first
            first = false
          else
            pdf.move_down 20
          end
          if t = make(table._head)
            pdf.table t, head
            pdf.move_down 20
          end
          pdf.text table.name, :style => :bold
          if t = make(table._body)
            pdf.move_down 10
            pdf.table t, body
          end
        end

        pdf.number_pages(*number_pages)
      end
      
      if stamp
        raise "#{stamp} not readable or does not exist" unless File.readable?(stamp)
        require 'posix/spawn'
        POSIX::Spawn::Child.new 'pdftk', tmp_path, 'stamp', stamp, 'output', "#{tmp_path}.stamped"
        FileUtils.mv "#{tmp_path}.stamped", tmp_path
      end

      @path = tmp_path
    end

    def cleanup
      safe_delete @path if @path
    end

    private

    def make(src)
      return unless src
      memo = []
      src.each(report) do |row|
        converted = row.to_a.map do |cell|
          case cell
          when TrueClass, FalseClass
            cell.to_s
          else
            cell
          end
        end
        memo << converted
      end
      memo if memo.length > 0
    end

    def font_name
      'MainFont'
    end
    
    def font
      DEFAULT_FONT.merge report.class.pdf_format.fetch(:font, {})
    end
    
    def document
      DEFAULT_DOCUMENT.merge report.class.pdf_format.fetch(:document, {})
    end

    def head
      DEFAULT_HEAD.merge report.class.pdf_format.fetch(:head, {})
    end

    def body
      DEFAULT_BODY.merge report.class.pdf_format.fetch(:body, {})
    end

    def stamp
      report.class.pdf_format[:stamp]
    end

    def number_pages
      report.class.pdf_format.fetch :number_pages, DEFAULT_NUMBER_PAGES
    end
  end
end
