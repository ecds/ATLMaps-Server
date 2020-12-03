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
  # HTTParty::Basement.default_options.update(verify: false)
  # mount_uploader :thumb, RasterThumbnailUploader
  has_one_attached :tmp_thumb
  has_one_attached :thumbnail

  has_many :raster_layer_project, dependent: :destroy
  has_many :projects, through: :raster_layer_project

  # Get random map that has less than three tags
  scope :test, -> { all unless :tags.empty? }

  # @!attribute [r] url
  # @return [String]
  # Convience attribute to the GeoServer endpoint
  def url
    return "#{institution.geoserver}#{workspace}/gwc/service/wms?tiled=true"
  end

  # def thumb_url
  #   url_for(tmp_thumb)
  # end

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
    wgs84_proj4 = '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'
    factory = RGeo::Geographic.spherical_factory(srid: 4326, proj4: wgs84_proj4)
    nw = factory.point(maxx, maxy)
    ne = factory.point(minx, maxy)
    se = factory.point(minx, miny)
    # 9.547 = Zoom level 14
    # http://wiki.openstreetmap.org/wiki/Zoom_levels
    height = (ne.distance(se) / 19.093).to_i
    width = (ne.distance(nw) / 19.093).to_i
    request = "#{institution.geoserver}#{workspace}/wms?service=WMS&version=1.1.0&request=GetMap&layers=#{workspace}:#{name}&styles=&bbox=#{minx},#{miny},#{maxx},#{maxy}&width=#{width}&height=#{height}&srs=EPSG:#{institution.srid}&format=image%2Fpng"
    response = nil
    filename = "/data/tmp/#{name}.png"
    File.open(filename, 'wb') do |file|
      response =
        HTTParty.get(request, stream_body: true) do |fragment|
          file.write(fragment)
        end
      self.thumb = file
      # file.delete
    end
  end
end
