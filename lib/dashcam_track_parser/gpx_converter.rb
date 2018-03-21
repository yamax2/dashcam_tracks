require 'time'

module DashcamTrackParser
  class GpxConverter
    attr_reader :nmea_file

    def initialize(nmea_file)
      @nmea_file = nmea_file

      read_lines
    end

    def call
      now = Time.now.utc.strftime(NmeaReader::TIME_FORMAT)

      puts "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\r"
      puts "<gpx version=\"1.0\"\r\n" \
           "     creator=\"DashCam Tracks\"\r\n" \
           "     xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns=\"http://www.topografix.com/GPX/1/0\"\r\n"\
           "     xsi:schemaLocation=\"http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd\">\r"

      puts "<time>#{now}</time>\r"
      puts "<bounds minlat=\"#{reader.bounds.minlat}\" minlon=\"#{reader.bounds.minlon}\"" \
           " maxlat=\"#{reader.bounds.maxlat}\" maxlon=\"#{reader.bounds.maxlon}\"/>\r"

      puts "<trk>\r"
      puts "  <name>Test</name>\r"
      puts "  <desc></desc>\r"
      puts "  <time>#{now}</time>\r"
      puts "  <trkseg>\r"

      @lines.each do |line|
        puts "\t<trkpt lat=\"#{line[:lat]}\" lon=\"#{line[:lon]}\">" \
             "<time>#{line[:timestamp]}</time><course>#{line[:bb]}</course>" \
             "<speed>#{line[:speed]}</speed></trkpt>\r"
      end

      puts "  </trkseg>\r"
      puts "</trk>\r"
      puts "</gpx>\r"
    end

    private

    def read_lines
      @lines = []

      reader.read do |line|
        @lines << line if line[:lat] && line[:lon]
      end
    end

    def reader
      @reader ||= NmeaReader.new(nmea_file)
    end
  end
end
