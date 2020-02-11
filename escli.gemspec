$:.push File.expand_path("../lib", __FILE__)
require "escli/version"

Gem::Specification.new do |gem|
  gem.name = 'escli'
  gem.version = ESCLI::VERSION
  gem.authors = ['Zan Loy']
  gem.email = ['zan.loy@gmail.com']
  gem.homepage = 'https://github.com/zanloy/escli'
  gem.summary = 'Command line tool for easy ElasticSearch queries'
  gem.description = 'Command line tool for easy ElasticSearch queries'
  gem.license = 'MIT'

  gem.add_runtime_dependency 'thor'
  gem.add_runtime_dependency 'json'
  gem.add_runtime_dependency 'yaml'
  gem.add_runtime_dependency 'lp'
  gem.add_development_dependency 'pry'

  gem.files = `git ls-files`.split("\n")
  gem.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.require_paths = ['lib']
end
