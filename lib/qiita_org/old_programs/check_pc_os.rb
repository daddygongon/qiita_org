class CheckPcOs
  def initialize()
    @macos = system "sw_vers"
    @winos = system "wmic.exe os get caption"
  end

  def return_os()
    if @macos
      return os = "mac"
    elsif @winos
      return os = "windows"
    else
      return nil
    end
  end
end

#p os = CheckPcOs.new.return_os()

