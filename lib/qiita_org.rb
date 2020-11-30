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
require "qiita_org/check_pc_os"
require "qiita_org/upload"
require "qiita_org/get_file_path"
require "qiita_org/show_file_and_url"
require "qiita_org/decide_option"
require "qiita_org/get_multiple_files"
#require "qiita_org/qiita_org_thor"

module QiitaOrg
  class CLI < Thor
    #    def initialize(*argv)
    #      super(*argv)
    #    end
    #
    def initialize(*argv)
      super(*argv)
    end

    desc "say_hello", "say_hello"

    def say_hello(*name)
      name = name[0] || "world"
      puts "Hello #{name}."
    end

    desc "post [FILE] [private/public/teams]", "post to qiita from org"

    def post(*argv)
      checkos = CheckPcOs.new
      os = checkos.return_os()

      if argv.size > 2
        GetMultipleFiles.new(argv, os, "post").run()
      elsif argv[-1].match(/(.+).org/) && argv.size != 1
        GetMultipleFiles.new(argv, os, "post").run()
      else
        p ["in qiita_org.rb", argv]
        p file = argv[0] || "README.org"
        p mode = argv[1] || DecideOption.new(file).decide_option()
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

    desc "upload [FILE] [teams/public/private]", "upload about image to qiita"

    def upload(*argv)
      checkos = CheckPcOs.new
      os = checkos.return_os()

      if argv.size > 2
        GetMultipleFiles.new(argv, os, "upload").run()
      elsif argv[-1].match(/(.+).org/) && argv.size != 1
        GetMultipleFiles.new(argv, os, "upload").run()
      else
        p file = argv[0] || "README.org"
        p mode = argv[1] || DecideOption.new(file).decide_option()

        qiita = QiitaFileUpLoad.new(file, mode, os).upload()
      end
=begin
      getpath = GetFilePath.new(file)
      paths = getpath.get_file_path()
      unless paths.empty?
        showfile = ShowFile.new(paths, file, mode, os)
        showfile.open_file_dir()
        showfile.open_qiita()

        puts "Input file URL's on #{file}? (y/n)".green
        ans = STDIN.getch

        if ans == "y"
          showfile.input_url_to_org()
        end
      end
=end
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
      checkos = CheckPcOs.new
      os = checkos.return_os()

      template = QiitaGetTemplate.new(os).run()
    end

    desc "all [teams/public/private] [options]", "post all org files in the directory"

    def all(*argv)
      #mode = argv[0] || false
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
