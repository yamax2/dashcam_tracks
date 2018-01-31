require './lib/dashcam_track_parser/nmea_reader'
require './lib/dashcam_track_parser/gpx_converter'

DashcamTrackParser::GpxConverter.new('samples/trendvision.nmea').call
