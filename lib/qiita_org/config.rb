require "colorize"
require "fileutils"
require "json"

class QiitaConfig
  def initialize(status, option, input)
    @option = option
    @input = input
    if status == "local"
      search = SearchConfPath.new(Dir.pwd, Dir.home)
      conf_dir = search.search_conf_path()
      if conf_dir == Dir.home
        @setup = File.join(Dir.pwd, ".qiita.conf")
      else
        @setup = File.join(conf_dir, ".qiita.conf")
      end
    else
      @setup = File.join(Dir.home, ".qiita.conf")
    end
  end

  # check qiita.conf or copy qiita.conf
  def check_or_copy_config()
    lib = File.expand_path("../../../lib", __FILE__)
    cp_file = File.join(lib, "qiita_org", ".qiita.conf")

    if File.exists?(@setup) # "# {ENV["HOME"]}/.qiita.conf")
      puts @setup.green
      print_config("now", "black")
    else
      FileUtils.cp(cp_file, @setup, verbose: true)
    end
  end

  def set_config()
    print_config("before", "red")
    items = JSON.load(File.read(@setup))
    items["#{@option}"] = @input.join(" ").strip
    conts = JSON.pretty_generate(items)
    File.write(@setup, conts)
    print_config("after", "green")
  end

  def print_config(status, color)
    puts status if status != "now"

    items = JSON.load(File.read(@setup))
    format = JSON.pretty_generate(items)
    File.write(@setup, format)

    conts = File.read(@setup)
    adjust_conts = conts.gsub(/{|}|,/, "{" => "", "}" => "", "," => "")
    puts adjust_conts if color == "black"
    puts adjust_conts.green if color == "green"
    puts adjust_conts.red if color == "red"
  end

  def run()
    if @option == nil
      check_or_copy_config()
    else
      set_config()
    end
  end
end
