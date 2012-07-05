require 'tmpdir'
require 'fileutils'

class Report
  # stolen from https://github.com/seamusabshere/unix_utils
  module Utils
    def tmp_path(options = {})
      ancestor = [ self.class.name, options[:hint] ].compact.join('_')
      extname = options.fetch(:extname, '.tmp')
      basename = File.basename ancestor.sub(/^\d{9,}_/, '')
      basename.gsub! /\W/, '_'
      time = Time.now.strftime('%H%M%S%L')
      File.join Dir.tmpdir, [time, '_', basename[0..(234-extname.length)], extname].join
    end

    def safe_delete(path)
      path = File.expand_path path
      unless File.dirname(path).start_with?(Dir.tmpdir)
        raise "Refusing to rm -rf #{path} because it's not in #{Dir.tmpdir}"
      end
      FileUtils.rm_rf path
    end
  end
end
