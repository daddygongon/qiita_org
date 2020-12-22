require 'hoe'
require './lib/pandoc/version.rb'

Hoe.spec 'pandoc' do

  self.version = Pandoc::VERSION

  self.summary = "pandoc - structured text document model / abstract syntax tree for all the world's formats"
  self.description = summary

  self.urls    = ['https://github.com/texti/pandoc']

  self.author  = 'Gerald Bauer'
  self.email   = 'ruby-talk@ruby-lang.org'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'CHANGELOG.md'

  self.extra_deps = []

  self.licenses = ['Public Domain']

  self.spec_extras = {
   required_ruby_version: '>= 2.2.2'
  }

end
