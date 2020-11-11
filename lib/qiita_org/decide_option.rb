class DecideOption
  def initialize(src)
    @src = src
  end

  def decide_option()
    lines = File.readlines(@src)

    lines.each do |line|
      m = []
      if m = line.match(/\#\+qiita_(.+): (.+)/)
        option = m[1] #line.match(/\#\+qiita_(.+): (.+)/)[1]
        unless option == "public" || option == "teams" || option == "private"
          next
        end
        return option
      end
    end
    option = "private"
    return option
  end
end

if __FILE__ == $0
  DecideOption.new("test.org").decide_option()
end
