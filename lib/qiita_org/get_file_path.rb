class GetFilePath
  def initialize(src)
    @src = src
  end

  def get_file_path()
    lines = File.readlines(@src.gsub(".org", ".md"))
    files = []
    lines.each do |line|
      if path2 = line.match(/\!\[img\]\(((.+))"(.+)"\)/)
        files << path2[2]
      end
    end

    paths = []
    files.each do |file|
      paths << File.join(Dir.pwd, file)
    end
    return paths
  end
end

#GetFilePath.new("thesis.org")
