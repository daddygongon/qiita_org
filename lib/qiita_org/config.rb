require "colorize"
require "fileutils"
require "json"

class QiitaConfig
  def initialize(option, input)
    @option = option
    @input = input
    @setup = "#{ENV["HOME"]}/.qiita.conf"
  end

  # check qiita.conf or copy qiita.conf
  def check_or_copy_config()
    lib = File.expand_path("../../../lib", __FILE__)
    cp_file = File.join(lib, "qiita_org", ".qiita.conf")

    if File.exists?("#{ENV["HOME"]}/.qiita.conf")
      puts @setup.green
      print_config("now", "black")
    else
      FileUtils.cp(cp_file, @setup, verbose: true)
    end
  end

  def set_access_token()
    print_config("before", "red")
    items = JSON.load(File.read(@setup))
    items["#{@option}"] = @input
    p conts = JSON.pretty_generate(items) #.to_json
    File.write(@setup, conts)
   # FileUtils.cp(@setup, "# {ENV["HOME"]}/config.json")
   # FileUtils.cp("# {ENV["HOME"]}/config.json", @setup)
    print_config("after", "green")
  end

  def set_teams_url()
    print_config("before", "red")
    conts = File.readlines(@setup)
    conts[2] = "    \"teams_url\": \"#{@input}\"\n"
    File.write(@setup, conts.join)
    print_config("after", "green")
  end

  def print_config(status, color)
    puts status if status != "now"
    conts = File.read(@setup)
    adjust_conts = conts.gsub(/{|}|,/, "{" => "", "}" => "", "," => "")
    puts adjust_conts if color == "black"
    puts adjust_conts.green if color == "green"
    puts adjust_conts.red if color == "red"
  end

  def run()
    check_or_copy_config() if @option == nil
    set_access_token() if @option == "access_token"
    set_teams_url() if @option == "teams_url"
  end
end
