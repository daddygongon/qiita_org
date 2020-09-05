require "fileutils"

class QiitaGetReadme
  def initialize()
    command = 'sw_vers'

    system 'sw_vers > hoge.txt'
    p version = File.read("hoge.txt")
    m = []
    puts m = version.match(/ProductName:\t(.+)\nProductVersion:\t(.+)\nBuildVersion:\t(.+)\n/)
    p m[1]

    p lib = File.expand_path("../../../lib", __FILE__)
    p s_file = File.join(lib, "qiita_org", "template.org")
    FileUtils.cp(s_file, ".", verbose: true)

    conts = File.read("template.org")
    File.write("template.org", conts + "#{m[1]}: #{m[2]}")
  end
end
