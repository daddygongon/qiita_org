class SearchConfPath
  def initialize(dir, home)
    @dir = dir
    @home = home
    #search_conf_path()
  end

  def search_conf_path()
    while @dir != @home
      if File.exists?(File.join(@dir, ".qiita.conf"))
        return @dir
      else
        @dir = @dir.match(/(.+)\//)[1]
      end
    end
    return @dir
  end
end
