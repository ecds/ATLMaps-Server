# frozen_string_literal: true

# /app/models/concerns/user_confirm.rb
# Concern provides code to ensure a user is confirmed.
module FixGeojsonFeature
  #
  # Some GeoJSON from the ArcGIS Open Data platform have invalid GeoJSON
  # For example
  #
  # "features": [{
  #   "type": "GeometryCollection", <-- Only "Feature" is allowed
  #   "geometries": [{ <-- should be "geometry" and must be a Hash
  #     "type": "MultiPolygon",
  #     "coordinates": [[[
  #         [-84.34816523074365, 33.805053839298864],
  #         [-84.3481640099526, 33.80503519896642],
  #         ...
  #     ]]]
  #   }],
  #   "properties": {}
  # }]
  #
  # So, we have to clean it up and make it look like:
  #
  # "features": [{
  #   "type": "Feature",
  #   "geometry": {
  #     "type": "GeometryCollection",
  #     "geometries": [
  #       {
  #         "type": "MultiPolygon",
  #         "coordinates": [[[
  #             [-84.34816523074365, 33.805053839298864],
  #             [-84.3481640099526, 33.80503519896642],
  #             ...
  #         ]]]
  #       }
  #     ]
  #   },
  #   "properties": {}
  # }]
  #
  # @param [Hash] feature GeoJSON Feature object
  #
  # @return [Hash] GeoJSON Feature object
  #
  def fix_feature(feature)
    if feature.key?(:geometries) && feature[:geometries].is_a?(Array)
      geometries = feature[:geometries]
      geometries.push(features[:geometry]) if feature.key?(:geometry)
      feature[:geometry] = {
        type: 'GeometryCollection',
        geometries: geometries
      }
      feature[:type] = 'Feature'
    end
    feature
  end
end
