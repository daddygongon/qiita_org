command = 'sw_vers'
output = ''
IO.popen(command) do |io|
  while io.gets()
    output << $_
  end
end

p output

#p output2 << system "sw_vers"

input = File.read('hoge.txt')
p input
