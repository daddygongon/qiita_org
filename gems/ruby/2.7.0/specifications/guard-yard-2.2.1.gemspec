# -*- encoding: utf-8 -*-
# stub: guard-yard 2.2.1 ruby lib

Gem::Specification.new do |s|
  s.name = "guard-yard".freeze
  s.version = "2.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Pan Thomakos".freeze]
  s.date = "2017-12-20"
  s.description = "Guard::Yard automatically monitors Yard Documentation.".freeze
  s.email = ["pan.thomakos@gmail.com".freeze]
  s.homepage = "https://github.com/panthomakos/guard-yard".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2".freeze)
  s.rubygems_version = "3.1.4".freeze
  s.summary = "Guard gem for YARD".freeze

  s.installed_by_version = "3.1.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<guard>.freeze, [">= 1.1.0"])
    s.add_runtime_dependency(%q<yard>.freeze, [">= 0.7.0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<rubocop>.freeze, ["= 0.51"])
  else
    s.add_dependency(%q<guard>.freeze, [">= 1.1.0"])
    s.add_dependency(%q<yard>.freeze, [">= 0.7.0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop>.freeze, ["= 0.51"])
  end
end
