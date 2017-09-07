# Modle calss to hold the features for the vector layers.
class VectorFeature < ApplicationRecord
    belongs_to :vector_layer
    after_save :update_vector_layer

    def geojson
        RGeo::GeoJSON.encode(geometry_collection)
    end

    def layer_title
        vector_layer.title
    end

    def name
        properties['name'] || properties['NAME'] || properties['title'] || properties['NEIGHBORHO'] || 'Untitled'
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

    def image
        properties['image'].to_h['url']
    end

    def audio
        properties['audio']
    end

    def feature_id
        layer_title.parameterize + '-' + id.to_s
    end

    private

    def update_vector_layer
        vector_layer.save
    end
end
