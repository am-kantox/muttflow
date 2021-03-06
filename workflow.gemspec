# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'workflow/version'

Gem::Specification.new do |gem|
  gem.name          = "workflow"
  gem.version       = Workflow::VERSION
  gem.authors       = ['Vladimir Dobriakov', 'Kantox LTD']
  gem.email         = ['vladimir@geekq.net', 'aleksei.matiushkin@kantox.com']
  gem.description = "    Workflow is a finite-state-machine-inspired API for modeling and interacting\n    with what we tend to refer to as 'workflow'.\n\n    * nice DSL to describe your states, events and transitions\n    * robust integration with ActiveRecord and non relational data stores\n    * various hooks for single transitions, entering state etc.\n    * convenient access to the workflow specification: list states, possible events\n      for particular state\n"
  gem.summary       = 'A replacement for acts_as_state_machine.'
  gem.homepage = 'http://www.geekq.net/workflow/'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(/^bin\//).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(/^(test|spec|features)\//)
  gem.require_paths = ['lib']

  gem.extra_rdoc_files = [
    'README.markdown'
  ]

  gem.add_dependency 'mutations', '~> 0.7.2'

  gem.add_development_dependency 'rdoc',    ['>= 3.12']
  gem.add_development_dependency 'bundler', ['>= 1.0.0']
  gem.add_development_dependency 'activerecord'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'minitest-reporters'
  gem.add_development_dependency 'rspec', '~> 2.12'
  gem.add_development_dependency 'cucumber', '~> 1.3'
  gem.add_development_dependency 'mocha'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'awesome_print'
  gem.add_development_dependency 'ruby-graphviz', ['~> 1.2.0']

  gem.required_ruby_version = '>= 1.9.2'
end
