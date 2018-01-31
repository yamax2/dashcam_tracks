require 'csv'
require 'time'
require 'ostruct'

module DashcamTrackParser
  class NmeaReader
    TIME_FORMAT = '%Y-%m-%dT%H:%M:%SZ'.freeze

    attr_reader :nmea_file, :bounds

    def initialize(nmea_file)
      @nmea_file = nmea_file
      @bounds = OpenStruct.new(minlat: 0, minlon: 0, maxlat: 0, maxlon: 0)
    end

    # ["$GNRMC", "061414.000", "A", "6046.6769", "N", "04619.2771",
    #  "E", "0.08", "201.75", "050118", nil, nil, "D*74"]
    def read
      CSV.open(nmea_file, 'r').each do |row|
        timestamp = Time.strptime("#{row[9]} #{row[1]}", '%d%m%y %H%M%S.%L')
        next if timestamp.year < 1990

        speed = (row[7].to_f * 1.852).round(2)
        bb = row[8].to_f

        lat, lon = geo_convert(
          lat_source: row[3],
          lon_source: row[5],
          sw: row[4],
          ww: row[6]
        )

        check_bounds lat, lon if lat && lon

        yield({
          timestamp: timestamp.strftime(TIME_FORMAT),
          bb: bb,
          speed: speed,
          lat: lat,
          lon: lon
        })
      end
    end

    private

    def check_bounds(lat, lon)
      bounds.minlat = lat if lat < bounds.minlat || bounds.minlat.zero?
      bounds.maxlat = lat if lat > bounds.maxlat

      bounds.minlon = lon if lon < bounds.minlon || bounds.minlon.zero?
      bounds.maxlon = lon if lon > bounds.maxlon
    end

    def geo_convert(lat_source:, lon_source:, sw:, ww:)
      return [nil, nil] unless lat_source && lon_source

      lat_deg  = lat_source[0..1]
      lat_min  = lat_source[2...-1]

      lat = (lat_deg.to_f + (lat_min.to_f / 60.0)).round(6)
      lat = -lat if sw == 'S'

      lon_deg = lon_source[0..2]
      lon_min = lon_source[3..-1]

      lon = (lon_deg.to_f + (lon_min.to_f / 60.0)).round(6)
      lon = -lon if ww == 'W'

      [lat, lon]
    end
  end
end
