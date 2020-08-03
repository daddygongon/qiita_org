require "thor"
require "qiita_org/version"
require "qiita_org/post"
#require "qiita_org/qiita_org_thor"

module QiitaOrg
  class CLI < Thor
#    def initialize(*argv)
#      super(*argv)
#    end
#
    desc "say_hello", "say_hello"
    def say_hello(*name)
      name = name[0] || "world"
      puts "Hello #{name}."
    end

    desc "post", "post to qiita from org"
    def post(*argv)
      p ['in qiita_org.rb',argv]
      p file = argv[0] || 'README.org'
      p mode = argv[1] || 'private'
      QiitaPost.new(file, mode)
    end
  end
end
