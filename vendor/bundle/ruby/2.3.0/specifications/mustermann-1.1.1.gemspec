# -*- encoding: utf-8 -*-
# stub: mustermann 1.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "mustermann"
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Konstantin Haase", "Zachary Scott"]
  s.date = "2020-01-03"
  s.description = "A library implementing patterns that behave like regular expressions."
  s.email = "sinatrarb@googlegroups.com"
  s.homepage = "https://github.com/sinatra/mustermann"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.2.0")
  s.rubygems_version = "2.5.2.1"
  s.summary = "Your personal string matching expert."

  s.installed_by_version = "2.5.2.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby2_keywords>, ["~> 0.0.1"])
    else
      s.add_dependency(%q<ruby2_keywords>, ["~> 0.0.1"])
    end
  else
    s.add_dependency(%q<ruby2_keywords>, ["~> 0.0.1"])
  end
end
