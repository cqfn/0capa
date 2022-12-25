# -*- encoding: utf-8 -*-
# stub: celluloid 0.18.0 ruby lib

Gem::Specification.new do |s|
  s.name = "celluloid".freeze
  s.version = "0.18.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 2.0.0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/celluloid/celluloid/issues", "changelog_uri" => "https://github.com/celluloid/celluloid/blob/master/CHANGES.md", "documentation_uri" => "https://www.rubydoc.info/gems/celluloid", "homepage_uri" => "https://celluloid.io/", "mailing_list_uri" => "http://groups.google.com/group/celluloid-ruby", "source_code_uri" => "https://github.com/celluloid/celluloid", "wiki_uri" => "https://github.com/celluloid/celluloid/wiki" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Tony Arcieri".freeze, "Donovan Keme".freeze]
  s.date = "2020-12-06"
  s.description = "Celluloid enables people to build concurrent programs out of concurrent objects just as easily as they build sequential programs out of sequential objects".freeze
  s.email = ["bascule@gmail.com".freeze, "code@extremist.digital".freeze]
  s.homepage = "https://github.com/celluloid/celluloid".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.2.6".freeze)
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Actor-based concurrent object framework for Ruby".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<timers>.freeze, ["~> 4"])
  else
    s.add_dependency(%q<timers>.freeze, ["~> 4"])
  end
end
