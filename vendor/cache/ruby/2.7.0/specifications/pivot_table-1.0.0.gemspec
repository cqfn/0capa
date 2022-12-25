# -*- encoding: utf-8 -*-
# stub: pivot_table 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "pivot_table".freeze
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ed James".freeze]
  s.date = "2016-04-15"
  s.description = "Transform an ActiveRecord-ish data set into a pivot table of objects".freeze
  s.email = "ed.james.email@gmail.com".freeze
  s.homepage = "https://github.com/edjames/pivot_table".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 1.9".freeze)
  s.rubygems_version = "3.1.2".freeze
  s.summary = "pivot_table-1.0.0".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.4"])
    s.add_development_dependency(%q<growl>.freeze, ["~> 1.0"])
    s.add_development_dependency(%q<guard-rspec>.freeze, ["~> 4.6"])
  else
    s.add_dependency(%q<rspec>.freeze, ["~> 3.4"])
    s.add_dependency(%q<growl>.freeze, ["~> 1.0"])
    s.add_dependency(%q<guard-rspec>.freeze, ["~> 4.6"])
  end
end
