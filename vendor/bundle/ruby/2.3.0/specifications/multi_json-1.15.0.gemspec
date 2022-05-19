# -*- encoding: utf-8 -*-
# stub: multi_json 1.15.0 ruby lib

Gem::Specification.new do |s|
  s.name = "multi_json"
  s.version = "1.15.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/intridea/multi_json/issues", "changelog_uri" => "https://github.com/intridea/multi_json/blob/v1.15.0/CHANGELOG.md", "documentation_uri" => "https://www.rubydoc.info/gems/multi_json/1.15.0", "source_code_uri" => "https://github.com/intridea/multi_json/tree/v1.15.0", "wiki_uri" => "https://github.com/intridea/multi_json/wiki" } if s.respond_to? :metadata=
  s.require_paths = ["lib"]
  s.authors = ["Michael Bleigh", "Josh Kalderimis", "Erik Michaels-Ober", "Pavel Pravosud"]
  s.date = "2020-07-10"
  s.description = "A common interface to multiple JSON libraries, including Oj, Yajl, the JSON gem (with C-extensions), the pure-Ruby JSON gem, NSJSONSerialization, gson.rb, JrJackson, and OkJson."
  s.email = ["michael@intridea.com", "josh.kalderimis@gmail.com", "sferik@gmail.com", "pavel@pravosud.com"]
  s.homepage = "https://github.com/intridea/multi_json"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.2.1"
  s.summary = "A common interface to multiple JSON libraries."

  s.installed_by_version = "2.5.2.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["~> 10.5"])
      s.add_development_dependency(%q<rspec>, ["~> 3.9"])
    else
      s.add_dependency(%q<rake>, ["~> 10.5"])
      s.add_dependency(%q<rspec>, ["~> 3.9"])
    end
  else
    s.add_dependency(%q<rake>, ["~> 10.5"])
    s.add_dependency(%q<rspec>, ["~> 3.9"])
  end
end
