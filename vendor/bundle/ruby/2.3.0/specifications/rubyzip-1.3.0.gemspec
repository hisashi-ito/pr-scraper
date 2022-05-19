# -*- encoding: utf-8 -*-
# stub: rubyzip 1.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rubyzip"
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/rubyzip/rubyzip/issues", "changelog_uri" => "https://github.com/rubyzip/rubyzip/blob/v1.3.0/Changelog.md", "documentation_uri" => "https://www.rubydoc.info/gems/rubyzip/1.3.0", "source_code_uri" => "https://github.com/rubyzip/rubyzip/tree/v1.3.0", "wiki_uri" => "https://github.com/rubyzip/rubyzip/wiki" } if s.respond_to? :metadata=
  s.require_paths = ["lib"]
  s.authors = ["Alexander Simonov"]
  s.date = "2019-09-25"
  s.email = ["alex@simonov.me"]
  s.homepage = "http://github.com/rubyzip/rubyzip"
  s.licenses = ["BSD 2-Clause"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = "2.5.2.1"
  s.summary = "rubyzip is a ruby module for reading and writing zip files"

  s.installed_by_version = "2.5.2.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["~> 10.3"])
      s.add_development_dependency(%q<pry>, ["~> 0.10"])
      s.add_development_dependency(%q<minitest>, ["~> 5.4"])
      s.add_development_dependency(%q<coveralls>, ["~> 0.7"])
      s.add_development_dependency(%q<rubocop>, ["~> 0.49.1"])
    else
      s.add_dependency(%q<rake>, ["~> 10.3"])
      s.add_dependency(%q<pry>, ["~> 0.10"])
      s.add_dependency(%q<minitest>, ["~> 5.4"])
      s.add_dependency(%q<coveralls>, ["~> 0.7"])
      s.add_dependency(%q<rubocop>, ["~> 0.49.1"])
    end
  else
    s.add_dependency(%q<rake>, ["~> 10.3"])
    s.add_dependency(%q<pry>, ["~> 0.10"])
    s.add_dependency(%q<minitest>, ["~> 5.4"])
    s.add_dependency(%q<coveralls>, ["~> 0.7"])
    s.add_dependency(%q<rubocop>, ["~> 0.49.1"])
  end
end
