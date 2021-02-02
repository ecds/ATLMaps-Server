# frozen_string_literal: true

require 'cgi'

# Model class for vector layers.
class VectorLayer < Layer
  has_many :vector_layer_project, dependent: :destroy
  has_many :projects, through: :vector_layer_project

  serialize :tmp_geojson, HashSerializer

  before_create :clean_geojson

  before_save :find_tmp_type, :find_keywords, :guess_data_type, :create_default_color_map
  before_create :ensure_name

  enum geometry_type: { GeometryCollection: 0, LineString: 1, MultiLineString: 2, MultiPolygon: 3, Point: 4 }
  enum data_format: { geojson: 0, pbf: 1, remote: 2 }
  enum data_type: { qualitative: 0, quantitative: 1 }

  scope :qualitative_layers, -> { where(data_type: 'qualitative') }
  scope :quantitative_layers, -> { where(data_type: 'quantitative') }
  scope :by_data_type, ->(type) { where(data_type: type) }

  #
  # Default factory to use when createing features.
  #
  # @return [RGeo::Geographic::Factory] https://www.rubydoc.info/github/dazuma/rgeo/RGeo%2FGeographic.simple_mercator_factory
  #
  def geo_factory
    RGeo::Geographic.simple_mercator_factory
  end

  #
  # Geoserver endpoint for Protobuff Vector Tiles
  #
  # @return [String] geoserver endpoint
  #
  def geo_url
    return "#{institution.geoserver}/gwc/service/tms/1.0.0/#{workspace}:#{title}@EPSG:900913@pbf/{z}/{x}/{-y}.pbf"
  end

  #
  # GeoJSON representation of layer.
  #
  # TODO: There will be other cases to handle.
  # TODO: Should this return a RGeo::GeoJSON object>
  #
  # @return [JSON] GeoJSON representation of layer
  #
  def geojson
    case data_format
    when 'geojson'
      return tmp_geojson
    when 'pbf'
      return geo_url
    when 'remote'
      return remote_geojson
    else
      return
    end
  end

  #
  # Collection of properties from the related features.
  #
  # @return [Array] data properties
  #
  def properties
    return if geojson.nil?

    return if geojson['features'].nil?

    props = geojson['features'].map { |feature| feature['properties'].keys }.flatten.sort.uniq!
    return if props.nil?

    props.map { |prop| { "#{prop}": geojson['features'].map { |feature| feature['properties'][prop] }.uniq } }
  end

  #
  # Temporary color.
  #
  # @return [String] hex color value.
  #
  def tmp_color
    return ColorBrewer.new.random
  end

  # private

  def remote_geojson
    if workspace.present?
      geo_url = "#{institution.geoserver}#{workspace}/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=#{workspace}:#{name}&outputFormat=application%2Fjson"
      return JSON.parse(HTTParty.get(geo_url).body)
    else
      begin
        return JSON.parse(HTTParty.get(url).body)
      rescue StandardError
        return
      end
    end
  end

  #
  # Set type based on feature types
  #
  def find_tmp_type
    return if geojson.nil?

    begin
      types =
        if geojson[:features].first.key?(:geometry)
          geojson[:features].map { |f| f[:geometry][:type] }.uniq
        elsif geojson[:features].first.key?(:geometries)
          geometries = geojson[:features].pluck(:geometries)
          geometries.flatten.pluck(:type).uniq
        end

      self.geometry_type =
        if types.length == 1
          types[0]
        else
          'GeometryCollection'
        end
    rescue NoMethodError
      self.tmp_type = nil
    end
  end

  #
  # Guess the data type based on typs of geometry.
  #
  # @return [String] Type of data layer
  #
  def guess_data_type
    return if data_type.present?

    self.data_type = geometry_type.include?('Point') ? 'qualitative' : 'quantitative'
  end

  #
  # Generates a random string for the name if needed.
  #
  def ensure_name
    # Name is the persistant unique identifier. We have to have one.
    self.name = SecureRandom.hex(4) if name.nil?
  end

  #
  # Calculates the bounding box based on the features.
  #
  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def calculate_boundingbox
    return if geojson.nil?

    return if pbf?

    begin
      self.maxx = RGeo::GeoJSON.decode(geojson).map { |feature| RGeo::Cartesian::BoundingBox.create_from_geometry(feature.geometry.envelope).max_x }.max
      self.maxy = RGeo::GeoJSON.decode(geojson).map { |feature| RGeo::Cartesian::BoundingBox.create_from_geometry(feature.geometry.envelope).max_y }.max
      self.minx = RGeo::GeoJSON.decode(geojson).map { |feature| RGeo::Cartesian::BoundingBox.create_from_geometry(feature.geometry.envelope).min_x }.min
      self.miny = RGeo::GeoJSON.decode(geojson).map { |feature| RGeo::Cartesian::BoundingBox.create_from_geometry(feature.geometry.envelope).min_y }.min

      max_point = geo_factory.point(maxx, maxy)
      min_point = geo_factory.point(minx, miny)
      # If the min and max points are the the same, we need to bump one so the box will be a polygon.
      min_point = geo_factory.point(minx + 3, miny + 3) if max_point.distance(min_point).zero?
      self.boundingbox = RGeo::Cartesian::BoundingBox.create_from_points(max_point, min_point).to_geometry
    rescue NoMethodError
      nil
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  #
  # Collects all the descriptions, filters all the stopwords
  # sets the keywords property.
  #
  def find_keywords
    return if geojson.nil? || geojson['features'].nil?

    titles = geojson['features'].map { |l| ActionView::Base.full_sanitizer.sanitize(l['properties']['title']) }.join(' ').split
    descriptions = geojson['features'].map { |l| ActionView::Base.full_sanitizer.sanitize(l['properties']['description']) }.join(' ').split
    self.keywords = Stopwords.new.filter(titles + descriptions)
  end

  def create_default_color_map
    return if qualitative? || default_break_property.nil?

    self.color_map = ColorMap.new(geojson: geojson, property: default_break_property).create_map
  end

  #
  # <Description>
  #
  # @return [<Type>] <description>
  #
  def clean_geojson
    return if tmp_geojson.nil?

    tmp_geojson[:features].each do |feature|
      feature.delete(:geometries)
    end
  end

  # def defaults
  #   self.institution = Institution.find(1)
  #   self.tmp_type = 'Point'
  #   self.data_format = 'vector'
  #   self.active = true
  #   self.name = (0...8).map { rand(65..90).chr }.join.downcase
  # end
end
