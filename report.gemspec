# -*- encoding: utf-8 -*-
require File.expand_path('../lib/report/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Seamus Abshere"]
  gem.email         = ["seamus@abshere.net"]
  d = %q{DSL for creating clean CSV, XLSX, and PDF reports in Ruby. Extracted from Brighter Planet's corporate reporting system.}
  gem.description   = d
  gem.summary       = d
  gem.homepage      = "https://github.com/seamusabshere/report"

  gem.files         = `git ls-files`.split($\)
  # gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "report"
  gem.require_paths = ["lib"]
  gem.version       = Report::VERSION

  gem.add_runtime_dependency 'activesupport'
  gem.add_runtime_dependency 'xlsx_writer', '>=0.2.2'
  gem.add_runtime_dependency 'prawn'
  gem.add_runtime_dependency 'posix-spawn'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'remote_table'
  gem.add_development_dependency 'unix_utils'
  gem.add_development_dependency 'yard'
end
