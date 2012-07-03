require 'tmpdir'

module Report
  module Utils
    # stolen from https://github.com/seamusabshere/unix_utils
    def tmp_path(hint, extname = nil) # :nodoc:
      ancestor = [ self.class.name, hint.to_s ].join('_')
      extname ||= File.extname ancestor
      basename = File.basename ancestor.sub(/^report_\d{9,}_/, '')
      basename.gsub! /\W/, '_'
      time = Time.now.strftime('%H%M%S%L')
      File.join Dir.tmpdir, "report_#{time}_#{basename[0..(234-extname.length)]}#{extname}"
    end
  end
end
