require "thor"
require "colorize"
require "qiita_org/version"
require "qiita_org/post"
require "qiita_org/config"
require "qiita_org/get"
require "qiita_org/list"
require "qiita_org/get_template"
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
      p ["in qiita_org.rb", argv]
      p file = argv[0] || "README.org"
      p mode = argv[1] || "private"
      qiita = QiitaPost.new(file, mode)
      begin
        qiita.select_option(mode)
      rescue RuntimeError => e
        puts $!
      else
        qiita.run
      end
    end

    desc "config", "set config"

    def config(*argv)
      status = argv[0] || "local"
      option = argv[1] || nil
      input = [argv[2], argv[3], argv[4]]
      config =  QiitaConfig.new(status, option, input)
      config.run
    end

    desc "get", "get qiita report"

    def get(*argv)
      p mode = argv[0] || "qiita"
      p id = argv[1] || nil
      get =  QiitaGet.new(mode, id)
      get.run
    end

    desc "template", "make template.org"

    def template(*argv)
      template = QiitaGetTemplate.new()
    end

    desc "all", "post all org file in the directory"

    def all(*argv)
      Dir.glob("*.org").each do |org|
        puts org.blue
        if File.read(org).match(/#\+qiita_(.+)/)
          system ("qiita post #{org} open") if File.read(org).match(/#\+(.+)_public/)
          system ("qiita post #{org} teams") if File.read(org).match(/#\+(.+)_teams/)
          system ("qiita post #{org} private") if File.read(org).match(/#\+(.+)_private/)
        else
          system ("qiita post #{org}")
        end
      end
    end

    desc "list", "view qiita report list"

    def list(*argv)
      p mode = argv[0] || "qiita"
      QiitaList.new(mode)
    end
  end
end
