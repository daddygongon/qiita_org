require "fileutils"
require "colorize"

class QiitaGetTemplate
  def initialize()
    cp_template()
    check_write_header()
    check_write_contents()
  end

  def get_macos_version()
    system 'sw_vers > hoge.txt'
    version = File.read("hoge.txt")
    m = []
    m = version.match(/ProductName:\t(.+)\nProductVersion:\t(.+)\nBuildVersion:\t(.+)\n/)
    system 'rm hoge.txt'
    conts = File.read("template.org")
    conts << "\n![#{m[1]}-#{m[2]}](https://img.shields.io/badge/#{m[1].gsub(" ", "")}-#{m[2]}-brightgreen)\n"
    File.write("template.org", conts) # + "# {m[1]}: # {m[2]}\n")
  end

  def get_ruby_version()
    system 'ruby --version > hoge.txt'
    version = File.read("hoge.txt")
    m = []
    m = version.match(/ruby (.+) \((.+)/)
    system 'rm hoge.txt'
    conts = File.read("template.org")
    conts << "\n![ruby-#{m[1]}](https://img.shields.io/badge/ruby-#{m[1].gsub(" ", "")}-brightgreen)\n"
    File.write("template.org", conts) # + "ruby: # {m[1]}\n")
  end

  # cp template.org
  def cp_template()
    lib = File.expand_path("../../../lib", __FILE__)
    cp_file = File.join(lib, "qiita_org", "template.org")

    if File.exists?("./template.org")
      puts "template.org exists.".red
      exit
    else
      FileUtils.cp(cp_file, ".", verbose: true)
    end
  end

  def check_write_contents()
    ["MacOS", "ruby"].each do |src|
      print "Write #{src} version?(y/n) "
      ans = STDIN.gets.chomp
      next if ans == "n"
      if ans == "y"
        send("get_#{src.downcase}_version")
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

  def get_name()
    conts = File.readlines("template.org")
    p "Type your name"
    name = STDIN.gets
    conts[3] = "#+AUTHOR: #{name}"
    File.write("template.org", conts.join)
  end

  def get_email()
    conts = File.readlines("template.org")
    p "Type your email"
    email = STDIN.gets
    conts[4] = "#+EMAIL:     (concat \"#{email.chomp}\")\n"
    File.write("template.org", conts.join)
  end
end
