# Modle calss to hold the features for the vector layers.
class VectorFeature < ActiveRecord::Base
    belongs_to :vector_layer

    def geojson
        RGeo::GeoJSON.encode(geometry_collection)
    end

    def layer_title
        vector_layer.title
    end

    def name
        properties['name'] || properties['NAME'] || properties['title'] || 'Untitled'
    end

    def description
        properties['description']
    end

    def youtube
        return properties['gx_media_links'] if properties['gx_media_links'].include? 'youtube'
        properties['video'].include? 'youtube'
    rescue
        return nil
    end

    def vimeo
        return if properties['gx_media_links'].include? 'vimeo'
        properties['video'].include? 'vimeo'
    rescue
        return nil
    end

    def images
        properties['images'].to_a
    end

    def audio
        properties['audio']
    end
end
