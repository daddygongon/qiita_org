# -*- coding: utf-8 -*-
require "thor"
require "colorize"
require "io/console"
require "qiita_org/version"
require "qiita_org/post"
require "qiita_org/config"
require "qiita_org/get"
require "qiita_org/list"
require "qiita_org/all"
require "qiita_org/get_template"
require "qiita_org/upload"
require "qiita_org/get_multiple_files"
require "qiita_org/base"

module QiitaOrg
  class CLI < Thor
    def initialize(*argv)
      super(*argv)
      @base = QiitaBase.new()
    end

    desc "say_hello", "say_hello"

    def say_hello(*name)
      name = name[0] || "world"
      puts "Hello #{name}."
    end

    desc "post [FILE] [private/public/teams]", "post to qiita from org"

    def post(*argv)
      os = @base.check_pc_os()

      if argv.size > 2
        GetMultipleFiles.new(argv, os, "post").run()
      else #if argv.size > 1
        if argv[-1].match(/(.+).org/)
          GetMultipleFiles.new(argv, os, "post").run()
        else
          p ["in qiita_org.rb", argv]
          p file = argv[0] || "README.org"
          p mode = argv[1] || @base.pick_up_option(file)
          qiita = QiitaPost.new(file, mode, os)
          begin
            qiita.select_option(mode)
          rescue RuntimeError => e
            puts $!
          else
            qiita.run
          end
        end
      end
    end

    desc "upload [FILE] [teams/public/private]", "upload about image to qiita"

    def upload(*argv)
      os = @base.check_pc_os()

      if argv.size > 2
        GetMultipleFiles.new(argv, os, "upload").run()
      else #if argv.size > 1
        if argv[-1].match(/(.+).org/)
          GetMultipleFiles.new(argv, os, "upload").run()
        else
          p file = argv[0] || "README.org"
          p mode = argv[1] || @base.pick_up_option(file)

          qiita = QiitaFileUpLoad.new(file, mode, os).upload()
        end
      end
    end

    desc "config [global/local] [option] [input]", "set config"

    def config(*argv)
      status = argv[0] || "local"
      option = argv[1] || nil
      input = [argv[2], argv[3], argv[4]]
      config =  QiitaConfig.new(status, option, input)
      config.run
    end

    desc "get [qiita/teams] [ITEM_ID]", "get qiita report"

    def get(*argv)
      p mode = argv[0] || "qiita"
      p id = argv[1] || nil
      get =  QiitaGet.new(mode, id)
      get.run
    end

    desc "template", "make template.org"

    def template(*argv)
      os = @base.check_pc_os()
      filename = argv[0] || "template.org"
      filename = (filename.include?(".org"))? filename : "#{filename}.org"

      template = QiitaGetTemplate.new(os, filename).run()
    end

    desc "all [teams/public/private] [options]", "post all org files in the directory"

    def all(*argv)
      QiitaAll.new(argv).run()
    end

    desc "list [qiita/teams]", "view qiita report list"

    def list(*argv)
      p mode = argv[0] || "qiita"
      QiitaList.new(mode)
    end

    desc "version", "show version"

    def version
      puts QiitaOrg::VERSION
    end
  end
end
