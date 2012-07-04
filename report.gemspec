# -*- encoding: utf-8 -*-
require File.expand_path('../lib/report/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Seamus Abshere"]
  gem.email         = ["seamus@abshere.net"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "report"
  gem.require_paths = ["lib"]
  gem.version       = Report::VERSION

  gem.add_runtime_dependency 'activesupport'
  gem.add_runtime_dependency 'xlsx_writer'
  gem.add_runtime_dependency 'prawn'
  gem.add_runtime_dependency 'posix-spawn'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'remote_table'
  gem.add_development_dependency 'unix_utils'
end
