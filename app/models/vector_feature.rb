# Modle calss to hold the features for the vector layers.
class VectorFeature < ApplicationRecord
    include Nokogiri
    belongs_to :vector_layer # , autosave: true
    # after_save :update_vector_layer

    def geojson
        geojson = RGeo::GeoJSON.encode(public_send(geometry_type.to_s.underscore))
        geojson['properties'] = properties
        return geojson
    end

    def layer_title
        vector_layer.title
    end

    def name
        properties['name'] || properties['NAME'] || properties['title'] || properties['NEIGHBORHOOD'] || 'Untitled'
    end

    def description
    #     Nokogiri::HTML.fragment(properties['description']).children.first.text
    # rescue NoMethodError =>
    #     properties['description']
        properties['description']
    end

    def youtube
        return nil unless properties['gx_media_links'] || properties['video']
        return properties['gx_media_links'] if properties.key?('gx_media_links') and properties['gx_media_links'].include? 'youtube'
        return properties['video'] if properties.key?('video') and properties['video'].include? 'youtube'
    end

    def vimeo
        return if properties['gx_media_links'].include? 'vimeo'
        properties['video'].include? 'vimeo'
    rescue
        return nil
    end

    def images
        return nil if properties['images'].is_a? String
        properties['images'].to_a
    end

    def image
        return nil if properties['images'].is_a? String
        properties['image'].to_h['url']
    # rescue
    #     return nil
    end

    def audio
        properties['audio']
    end

    def filters
        properties['filters']
    end

    def color_name
        return if filters.nil?
        color_name = if filters['grade'] == 'A'
                         'green-500'
                     elsif filters['grade'] == 'B'
                         'blue-600'
                     elsif filters['grade'] == 'C'
                         'yellow-500'
                     elsif filters['grade'] == 'D'
                         'red-600'
                     end
        return color_name
    end

    def color_hex
        return if filters.nil?
        color_hex = if filters['grade'] == 'A'
                        '#4CAF50'
                    elsif filters['grade'] == 'B'
                        '#1E88E5'
                    elsif filters['grade'] == 'C'
                        '#FFEB3B'
                    elsif filters['grade'] == 'D'
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
end
