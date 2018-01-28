DELIMITER = "\x00\x99\x20\x00".freeze

out = File.open('1.txt', 'w')

begin
  IO.foreach('samples/datakam.data', DELIMITER) do |line|
    line.strip.scan(/\$GNRMC.*;/).each { |data| out.puts(data) }
  end
ensure
  out.close
end

# puts content.split("\x00\x50\x20\x00").size
