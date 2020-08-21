lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative "lib/qiita_org/version"


Gem::Specification.new do |spec|
  spec.name = "qiita_org"
  spec.version = QiitaOrg::VERSION
  spec.authors = ["Kenta Yamamoto"]
  spec.email = ["knt.0603.y@gmail.com"]

  spec.summary = %q{this is qiita post gem from org.}
  spec.description = %q{qiita_org gem to post qiita from org.}
  spec.homepage = "https://github.com/yamatoken/qiita_org"
  spec.license = "MIT"
  # spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "> 1.16"
  spec.add_development_dependency "rake", "> 13.0.1"
  spec.add_dependency "thor"
  spec.add_dependency "command_line", "> 2.0.0"
  spec.add_dependency "colorize"
  spec.add_dependency "fileutils"
  #spec.add_dependency "pandoc"
 # spec.add_development_dependency "pandoc", "> 2.9.2.1"
end
