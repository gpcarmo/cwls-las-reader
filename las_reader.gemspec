# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'las_reader/version'

Gem::Specification.new do |gem|
  gem.name          = "las_reader"
  gem.version       = LasReader::VERSION
  gem.authors       = ["Gilberto P. Carmo Jr."]
  gem.email         = ["gpcarmo@gmail.com"]
  gem.description   = %q{A simple gem to read CWLS-LAS file format. File in this format will contain well log data in ASCII format}

  gem.summary       = %q{Read CWLS LAS files}
  gem.homepage      = "https://github.com/gpcarmo/cwls-las-reader"
  gem.licenses      = ['MIT']

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency  "rspec"
  
end
