# -*- encoding: utf-8 -*-
# stub: rack 2.2.3 ruby lib

Gem::Specification.new do |s|
  s.name = "rack"
  s.version = "2.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/rack/rack/issues", "changelog_uri" => "https://github.com/rack/rack/blob/master/CHANGELOG.md", "documentation_uri" => "https://rubydoc.info/github/rack/rack", "source_code_uri" => "https://github.com/rack/rack" } if s.respond_to? :metadata=
  s.require_paths = ["lib"]
  s.authors = ["Leah Neukirchen"]
  s.date = "2020-06-15"
  s.description = "Rack provides a minimal, modular and adaptable interface for developing\nweb applications in Ruby. By wrapping HTTP requests and responses in\nthe simplest way possible, it unifies and distills the API for web\nservers, web frameworks, and software in between (the so-called\nmiddleware) into a single method call.\n"
  s.email = "leah@vuxu.org"
  s.executables = ["rackup"]
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG.md", "CONTRIBUTING.md"]
  s.files = ["CHANGELOG.md", "CONTRIBUTING.md", "README.rdoc", "bin/rackup"]
  s.homepage = "https://github.com/rack/rack"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0")
  s.rubygems_version = "2.5.2.1"
  s.summary = "A modular Ruby webserver interface."

  s.installed_by_version = "2.5.2.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<minitest>, ["~> 5.0"])
      s.add_development_dependency(%q<minitest-sprint>, [">= 0"])
      s.add_development_dependency(%q<minitest-global_expectations>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<minitest>, ["~> 5.0"])
      s.add_dependency(%q<minitest-sprint>, [">= 0"])
      s.add_dependency(%q<minitest-global_expectations>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<minitest>, ["~> 5.0"])
    s.add_dependency(%q<minitest-sprint>, [">= 0"])
    s.add_dependency(%q<minitest-global_expectations>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
