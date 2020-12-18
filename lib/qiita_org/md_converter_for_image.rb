class MdConverter
  def initialize()

  end

  def convert_for_image(lines)
    lines.each_with_index do |line, i|
      m = []
      if m = line.match(/\[\!\[img\]\((.+) "(.+)"\)\]\((.+)\)/)
        path = File.basename(m[1])
        url = m[3]
        lines[i] = "![#{path}](#{url})\n"
      elsif m = line.match(/\[\!\[img\]\((.+)\)\]\((.+)\)/)
        path = File.basename(m[1])
        url = m[2]
        lines[i] = "![#{path}](#{url})\n"
      else
        next
      end
    end

    return lines
  end
end

if __FILE__ == $0
  p lines = File.readlines("test.md")
  p lines2 = MdConverter.new(lines).convert_for_image()
end
