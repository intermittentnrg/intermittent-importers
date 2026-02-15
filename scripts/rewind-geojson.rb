#!/usr/bin/env ruby
require 'bundler/setup'
require 'json'

# Calculate signed area of a ring
# Positive = counter-clockwise, Negative = clockwise
def ring_area(ring)
  area = 0.0
  n = ring.length - 1 # Last point equals first
  (0...n).each do |i|
    x1, y1 = ring[i]
    x2, y2 = ring[(i + 1) % n]
    area += (x2 - x1) * (y2 + y1)
  end
  area / 2.0
end

# Reverse a ring (change winding order)
def reverse_ring(ring)
  # Keep first point at start, reverse the rest
  [ring[0]] + ring[1..-1].reverse
end

# Rewind a polygon ring based on whether it's exterior or interior
# Exterior rings (outer): should be counter-clockwise (positive area)
# Interior rings (holes): should be clockwise (negative area)
def rewind_ring(ring, is_exterior)
  area = ring_area(ring)

  if is_exterior
    # Exterior should be counter-clockwise (positive area in our calculation)
    # If negative, reverse it
    area < 0 ? reverse_ring(ring) : ring
  else
    # Interior should be clockwise (negative area in our calculation)
    # If positive, reverse it
    area > 0 ? reverse_ring(ring) : ring
  end
end

# Rewind a polygon
def rewind_polygon(coords)
  # First ring is exterior, rest are interior holes
  coords.map.with_index do |ring, idx|
    rewind_ring(ring, idx == 0)
  end
end

# Rewind a MultiPolygon
def rewind_multipolygon(coords)
  coords.map { |polygon| rewind_polygon(polygon) }
end

# Rewind any geometry
def rewind_geometry(geom)
  case geom['type']
  when 'Polygon'
    {
      'type' => 'Polygon',
      'coordinates' => rewind_polygon(geom['coordinates'])
    }
  when 'MultiPolygon'
    {
      'type' => 'MultiPolygon',
      'coordinates' => rewind_multipolygon(geom['coordinates'])
    }
  else
    geom
  end
end

# Load source file
geojson = JSON.parse(File.read('tmp/world.geojson'))

puts "Processing #{geojson['features'].length} features..."

# Process each feature
rewound_features = geojson['features'].map do |feature|
  {
    'type' => 'Feature',
    'properties' => feature['properties'],
    'geometry' => rewind_geometry(feature['geometry'])
  }
end

output = {
  'type' => 'FeatureCollection',
  'features' => rewound_features
}

# Write output
File.write('public/world-rewound.geojson', JSON.dump(output))

puts "Rewound #{rewound_features.length} features to public/world-rewound.geojson"
