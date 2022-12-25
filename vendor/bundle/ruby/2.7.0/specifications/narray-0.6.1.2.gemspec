# -*- encoding: utf-8 -*-
# stub: narray 0.6.1.2 ruby .
# stub: src/extconf.rb

Gem::Specification.new do |s|
  s.name = "narray".freeze
  s.version = "0.6.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = [".".freeze]
  s.authors = ["Masahiro Tanaka".freeze]
  s.date = "2016-02-11"
  s.description = "Numerical N-dimensional Array class".freeze
  s.email = "masa16.tanaka@gmail.com".freeze
  s.extensions = ["src/extconf.rb".freeze]
  s.files = ["src/extconf.rb".freeze]
  s.homepage = "http://masa16.github.io/narray/".freeze
  s.licenses = ["Ruby".freeze]
  s.rdoc_options = ["--title".freeze, "NArray".freeze, "--main".freeze, "NArray".freeze, "--exclude".freeze, "mk.*".freeze, "--exclude".freeze, "extconf\\.rb".freeze, "--exclude".freeze, "src/.*\\.h".freeze, "--exclude".freeze, "src/lib/".freeze, "--exclude".freeze, ".*\\.o".freeze, "--exclude".freeze, "narray\\.so".freeze, "--exclude".freeze, "libnarray\\.*".freeze]
  s.rubygems_version = "3.1.2".freeze
  s.summary = "N-dimensional Numerical Array class for Ruby".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version
end
