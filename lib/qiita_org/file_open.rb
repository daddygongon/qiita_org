class FileOpen
  def initialize(os)
    @os = os
  end

  def file_open(order)
    if @os == "mac"
      system "open #{order}"
    elsif @os == "windows"
      system "explorer.exe #{order}"
    else
      system "xdg-open #{order}"
    end
  end
end
