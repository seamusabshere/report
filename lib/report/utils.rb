require 'tmpdir'

class Report
  module Utils
    # stolen from https://github.com/seamusabshere/unix_utils
    def tmp_path(options = {})
      ancestor = [ self.class.name, options[:hint] ].compact.join('_')
      extname = options.fetch(:extname, '.tmp')
      basename = File.basename ancestor.sub(/^\d{9,}_/, '')
      basename.gsub! /\W/, '_'
      time = Time.now.strftime('%H%M%S%L')
      File.join Dir.tmpdir, [time, '_', basename[0..(234-extname.length)], extname].join
    end
  end
end
