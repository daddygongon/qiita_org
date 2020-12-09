require "fileutils"
require "colorize"
require "kconv"
#require "qiita_org/search_conf_path"
require "qiita_org/error_message.rb"

class QiitaGetTemplate
  def initialize(os, filename)
    @os = os
    @filename = filename
    #search = SearchConfPath.new(Dir.pwd, Dir.home)
    # @conf_dir = search.search_conf_path()
    @conf_dir = QiitaBase.new().search_conf_path(Dir.pwd, Dir.home)
    # check_write_header()
  end

  def get_macos_version()
    system 'sw_vers > hoge.txt'
    version = File.read("hoge.txt")
    m = []
    m = version.match(/ProductName:\t(.+)\nProductVersion:\t(.+)\nBuildVersion:\t(.+)\n/)
    system 'rm hoge.txt'
    conts = File.read(@filename)
    conts << "![#{m[1]}-#{m[2]}](https://img.shields.io/badge/#{m[1].gsub(" ", "")}-#{m[2]}-brightgreen) "
    File.write(@filename, conts) # + "# {m[1]}: # {m[2]}\n")
  end

  def get_windowsos_version()
    system 'wmic.exe os get caption > hoge1.txt'
    system 'wmic.exe os get osarchitecture > hoge2.txt'
    version1 = Kconv.tosjis(File.read("hoge1.txt"))
    version2 = Kconv.tosjis(File.read("hoge2.txt"))
    m1, m2 = [], []
    m1 = version1.match(/Caption\nMicrosoft (.+) (.+)/)
    m2 = version2.match(/OSArchitecture\n(.+)-bit/)
    system 'rm hoge1.txt'
    system 'rm hoge2.txt'
    conts = File.read(@filename)
    conts << "![#{m1[1]}-#{m1[2]}](https://img.shields.io/badge/#{m1[1].gsub(" ", "")}#{m1[2]}-#{m2[1]}bit-brightgreen) "
    File.write(@filename, conts) # + "# {m[1]}: # {m[2]}\n")
  end

  def get_ubuntu_version()
    system 'cat /etc/issue > hoge.txt'
    version = File.read("hoge.txt")
    m = []
    m = version.match(/(.+) (.+) LTS /)
    system 'rm hoge.txt'
    conts = File.read(@filename)
    conts << "![#{m[1]}-#{m[2]}](https://img.shields.io/badge/#{m[1]}-#{m[2]}-brightgreen) "
    File.write(@filename, conts)
  end

  def get_ruby_version()
    system 'ruby --version > hoge.txt'
    version = File.read("hoge.txt")
    m = []
    m = version.match(/ruby (.+) \((.+)/)
    system 'rm hoge.txt'
    conts = File.read(@filename)
    conts << "![ruby-#{m[1]}](https://img.shields.io/badge/ruby-#{m[1].gsub(" ", "")}-brightgreen) "
    File.write(@filename, conts) # + "ruby: # {m[1]}\n")
  end

  # cp template.org
  def cp_template()
    lib = File.expand_path("../../../lib", __FILE__)
    cp_file = File.join(lib, "qiita_org", "template.org")

    if File.exists?("./#{@filename}")
      puts "#{@filename} exists.".red
      exit
    else
      FileUtils.cp(cp_file, @filename, verbose: true)
    end
  end

  def check_write_contents()
    if @os == "mac"
      ["MacOS", "ruby"].each do |src|
        print "Write #{src} version?(y/n) "
        ans = STDIN.gets.chomp
        next if ans == "n"
        if ans == "y"
          send("get_#{src.downcase}_version")
        end
      end
    elsif @os == "windows"
      ["Ubuntu", "ruby"].each do |src|
        print "Write #{src} version?(y/n) "
        ans = STDIN.gets.chomp
        next if ans == "n"
        if ans == "y"
          send("get_#{src.downcase}_version")
        end
      end
    else
      ["ruby"].each do |src|
        print "Write #{src} version?(y/n) "
        ans = STDIN.gets.chomp
        next if ans == "n"
        if ans == "y"
          send("get_#{src.downcase}_version")
        end
      end
    end
  end

  def check_write_header()
    ["name", "email"].each do |src|
      print "Write your #{src}?(y/n) "
      ans = STDIN.gets.chomp
      next if ans == "n"
      if ans == "y"
        send("get_#{src}")
      end
    end
  end

=begin
  def get_name()
    conts = File.readlines(@filename)
    p "Type your name"
    name = STDIN.gets
    conts[3] = "#+AUTHOR: #{name}"
    File.write(@filename, conts.join)
  end

  def get_email()
    conts = File.readlines(@filename)
    p "Type your email"
    email = STDIN.gets
    conts[4] = "#+EMAIL:     (concat \"#{email.chomp}\")\n"
    File.write(@filename, conts.join)
  end
=end

  def set_name_and_email()
    conf_path = File.join(@conf_dir, ".qiita.conf")
    conf = JSON.load(File.read(conf_path))
    name = conf["name"]
    email = conf["email"]
    conts = File.readlines(@filename)
    conts[3] = "#+AUTHOR: #{name}\n"
    conts[4] = "#+EMAIL:     (concat \"#{email}\")\n"
    File.write(@filename, conts.join)
  end

  def run()
    ErrorMessage.new().config_set_error(@conf_dir)
    cp_template()
    set_name_and_email()
    check_write_contents()
  end
end
