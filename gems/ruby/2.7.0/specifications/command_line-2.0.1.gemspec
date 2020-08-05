# -*- encoding: utf-8 -*-
# stub: command_line 2.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "command_line".freeze
  s.version = "2.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/DragonRuby/command_line/blob/master/CHANGELOG.md", "homepage_uri" => "https://github.com/DragonRuby/command_line", "source_code_uri" => "https://github.com/DragonRuby/command_line" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Aaron Lasseigne".freeze]
  s.bindir = "exe".freeze
  s.date = "2020-04-17"
  s.description = "An easier way execute command line applications and get all of the output.".freeze
  s.email = ["aaron.lasseigne@dragonruby.org".freeze]
  s.homepage = "https://github.com/DragonRuby/command_line".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.4".freeze)
  s.rubygems_version = "3.1.4".freeze
  s.summary = "An easier way execute command line applications and get all of the output.".freeze

  s.installed_by_version = "3.1.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, ["~> 2.0"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.9"])
    s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.81.0"])
    s.add_development_dependency(%q<yard>.freeze, ["~> 0.9.20"])
    s.add_development_dependency(%q<redcarpet>.freeze, ["~> 3.5.0"])
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 2.0"])
    s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.9"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.81.0"])
    s.add_dependency(%q<yard>.freeze, ["~> 0.9.20"])
    s.add_dependency(%q<redcarpet>.freeze, ["~> 3.5.0"])
  end
end
