# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'speak_slow/version'

Gem::Specification.new do |gem|
  gem.name          = "speak_slow"
  gem.version       = SpeakSlow::VERSION
  gem.authors       = ["Yoichiro Hasebe"]
  gem.email         = ["yohasebe@gmail.com"]
  gem.description   = "SpeakSlow modifies audio files adding pauses and/or altering speed to suit for language study"
  gem.summary       = "SpeakSlow modify audio files changing speed and adding pauses"
  gem.homepage      = "http://github.com/yohasebe/speak_slow"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency "minitest"
  gem.add_runtime_dependency "progressbar"
  gem.add_runtime_dependency "trollop"  
end
