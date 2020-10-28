class DecideOption
  def initialize(src)
    @src = src
  end

  def decide_option()
    lines = File.readlines(@src)

    lines.each do |line|
      if line.match(/\#\+qiita_(.+): (.+)/)
        p option = line.match(/\#\+qiita_(.+): (.+)/)[1]
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
