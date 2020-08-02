require "thor"
require "qiita_org"

module QiitaOrg
  class CLI < Thor
    def initialize(*argv)
      super(*argv)
    end

    desc "say_hello", "say_hello"
    def say_hello(*argv)
      name = argv[0] || "world"
      puts "Hello #{name}."
    end
  end
end

