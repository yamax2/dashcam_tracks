require 'csv'

# ["$GNRMC", "061414.000", "A", "6046.6769", "N", "04619.2771",
#  "E", "0.08", "201.75", "050118", nil, nil, "D*74"]
CSV.open('samples/trendvision.nmea', 'r').each do |row|
  timestamp = DateTime.strptime("#{row[9]} #{row[1]}", '%d%m%y %H%M%S.%L')
  speed = (row[7].to_f * 1.852).round(2)
  bb = row[8].to_f

  if row[3] && row[5]
    lat_deg  = row[3][0..1]
    lat_min  = row[3][2...-1]

    lat = (lat_deg.to_f + (lat_min.to_f / 60.0)).round(6)
    lat = -lat if row[4] == 'S'

    lon_deg = row[5][0..2]
    lon_min = row[5][3..-1]

    lon = (lon_deg.to_f + (lon_min.to_f / 60.0)).round(6)
    lon = -lon if row[6] == 'W'
  else
    lat, lon = [nil, nil]
  end

  puts [timestamp, bb, speed, lat, lon].map(&:to_s).to_s
end
