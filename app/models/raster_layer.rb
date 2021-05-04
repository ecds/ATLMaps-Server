# frozen_string_literal: true

##
# Class that represents bitmap maps.
#
# has_many :raster_layer_project
#
# has_many :projects, through: :raster_layer_project, dependent: :destroy
#
# has_many :user_taggeds
#
# belongs_to :institution
#
# has_and_belongs_to_many :tags, dependent: :destroy
#
# Requires `bigdecimal` for lat and lng values.
#
# Include Arel::OrderPredications
# Required due to AREL bug https://github.com/rails/arel/issues/399
#
class RasterLayer < Layer
  include RGeo::Geographic::ProjectedGeometryMethods

  before_save :create_thumbnail

  has_one_attached :tmp_thumb
  has_one_attached :thumbnail

  has_many :raster_layer_project, dependent: :destroy
  has_many :projects, through: :raster_layer_project

  enum data_format: { wms: 0, tile: 1 }

  # Get random map that has less than three tags
  scope :test, -> { all unless :tags.empty? }

  # @!attribute [r] url
  # @return [String]
  # Convience attribute to the GeoServer endpoint
  def url
    return "#{institution.geoserver}#{workspace}/gwc/service/wms?tiled=true"
  end

  # @!attribute [r] layers
  # @return [String]
  # Convience attribute. Used in WMS call.
  def layers
    return "#{workspace}:#{name}"
  end

  private

  def calculate_boundingbox
    factory = RGeo::Geographic.simple_mercator_factory
    self.boundingbox = factory.polygon(
      factory.line_string(
        [
          factory.point(maxx, maxy),
          factory.point(minx, maxy),
          factory.point(minx, miny),
          factory.point(maxx, miny),
          factory.point(maxx, maxy)
        ]
      )
    )
  end

  def create_thumbnail
    return if thumbnail.attached?

    factory = RGeo::Geographic.spherical_factory
    nw = factory.point(maxx, maxy)
    ne = factory.point(minx, maxy)
    se = factory.point(minx, miny)
    # 9.547 = Zoom level 14
    # http://wiki.openstreetmap.org/wiki/Zoom_levels
    height = [Integer(ne.distance(se) / 19.093), 300].max
    width = [Integer(ne.distance(nw) / 19.093), 300].max
    request = "#{institution.geoserver}#{workspace}/wms?service=WMS&version=1.1.0&request=GetMap&layers=#{workspace}:#{name}&styles=&bbox=#{minx},#{miny},#{maxx},#{maxy}&width=#{width}&height=#{height}&srs=EPSG:#{institution.srid}&format=image%2Fpng"
    filename = "/data/tmp/#{name}.png"
    File.open(filename, 'wb') do |file|
      HTTParty.get(request, stream_body: true) do |fragment|
        file.write(fragment)
      end
      # file.delete
    end
    thumbnail.attach(io: File.open(filename), filename: "#{name}.png")
  end
end
