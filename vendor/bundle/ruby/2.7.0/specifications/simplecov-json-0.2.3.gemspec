# -*- encoding: utf-8 -*-
# stub: simplecov-json 0.2.3 ruby lib

Gem::Specification.new do |s|
  s.name = "simplecov-json".freeze
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Vicent Llongo".freeze]
  s.date = "2020-10-26"
  s.description = "JSON formatter for SimpleCov code coverage tool for ruby 1.9+".freeze
  s.email = ["villosil@gmail.com".freeze]
  s.homepage = "https://github.com/vicentllongo/simplecov-json".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.2".freeze
  s.summary = "JSON formatter for SimpleCov code coverage tool for ruby 1.9+".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<json>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  else
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<json>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
