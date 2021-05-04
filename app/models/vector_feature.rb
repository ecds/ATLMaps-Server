# frozen_string_literal: true

# Modle calss to hold the features for the vector layers.
class VectorFeature < ApplicationRecord
  include Nokogiri
  belongs_to :vector_layer
  before_create :parsejson_properties

  def geojson
    # geojson = RGeo::GeoJSON.encode(public_send(tmp_type.to_s.underscore))
    geojson = RGeo::GeoJSON.encode(geometry_collection)
    return if geojson.nil?

    geojson['properties'] = properties
    return geojson
  end

  def layer_title
    vector_layer.title
  end

  def name
    return if properties.nil?

    if properties.is_a?(String)
      json_properties = JSON.parse(properties.gsub('\\', ''))
    else
      json_properties = properties
    end
    properties[json_properties.keys.find { |k| k.downcase == 'name' }] || json_properties['title'] || json_properties['NEIGHBORHOOD'] || 'Untitled'
  end

  def description
    #   Nokogiri::HTML.fragment(properties['description']).children.first.text
    # rescue NoMethodError =>
    #   properties['description']
    properties['description']
  end

  def youtube
    return unless properties['gx_media_links'] || properties['video']
    return properties['gx_media_links'] if properties.key?('gx_media_links') && properties['gx_media_links'].include?('youtube')
    return properties['video'] if properties.key?('video') && properties['video'].include?('youtube')
  end

  def vimeo
    return properties['gx_media_links'] if properties['gx_media_links'].present? && properties['gx_media_links'].include?('vimeo')
    return properties['media'] if properties['media'].present? && properties['media'].include('vimeo')
    return properties['video'] if properties['video'].present? && properties['video'].include?('vimeo')

    return
  end

  def images
    return if properties['images'].is_a?(String
)
    properties['images'].to_a
  end

  def image
    return if properties['images'].nil?
    return if properties['images'].is_a?(String
)
    properties['image'].to_h['url']
    # rescue
    #   return nil
  end

  def audio
    properties['audio']
  end

  def filters
    properties['filters']
  end

  def color_name
    return if filters.nil?

    color_name =
 case filters['grade']
                   when 'A'
             'green-500'
                 when 'B'
             'blue-600'
                 when 'C'
             'yellow-500'
                 when 'D'
             'red-600'
           end
    return color_name
  end

  def color_hex
    return if filters.nil?

    color_hex =
      case filters['grade']
                        when 'A'
                  '#4CAF50'
                      when 'B'
                  '#1E88E5'
                      when 'C'
                  '#FFEB3B'
                      when 'D'
                  '#D81B60'
                end
          return color_hex
  end

  def feature_id
    layer_title.parameterize + '-' + id.to_s
  end

    private

    def update_vector_layer
      vector_layer.save
    end

    def parsejson_properties
      return if properties.nil?

      if properties.is_a?(String)
        properties = JSON.parse(properties)
      end
    end
end

