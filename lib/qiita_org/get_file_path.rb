class GetFilePath
  def initialize(src)
    @src = src
  end

  def get_file_path()
    #lines = File.readlines(@src.gsub(".org", ".md"))
    lines = File.readlines(@src)
    files = []
    lines.each do |line|
      #if path2 = line.match(/\!\[img\]\(((.+))/)# "(.+)"\)/)
      if path2 = line.match(/\[\[file\:(.+)\](.+)\]\]/) || line.match(/\[\[file:(.+)\]\]/)
        if path2[2] == nil
          files << path2[1]
          end
      end
    end

    #paths = []
    #files.each do |file|
      #paths << File.join(Dir.pwd, file)
    #end
    #return paths
    return files
  end
end

#GetFilePath.new("thesis.org")
