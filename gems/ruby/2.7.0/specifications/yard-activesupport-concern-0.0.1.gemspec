# -*- encoding: utf-8 -*-
# stub: yard-activesupport-concern 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "yard-activesupport-concern".freeze
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Olivier Lance @ Digital cuisine".freeze]
  s.date = "2015-06-02"
  s.description = "This is a YARD extension that brings support for modules making use of ActiveSupport::Concern. It makes YARD parse docstrings inside included and class_methods blocks and generate the proper documentation for them.".freeze
  s.email = ["olivier@digitalcuisine.fr".freeze]
  s.homepage = "https://github.com/digitalcuisine/yard-activesupport-concern".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.4".freeze
  s.summary = "A YARD plugin to handle modules using ActiveSupport::Concern".freeze

  s.installed_by_version = "3.1.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, ["~> 1.7"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_runtime_dependency(%q<yard>.freeze, [">= 0.8"])
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.7"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<yard>.freeze, [">= 0.8"])
  end
end
