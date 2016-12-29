# app/serializers/project_serializer.rb
class ProjectSerializer < ActiveModel::Serializer

    attributes :id,
               :name,
               :description,
               :center_lat,
               :center_lng,
               :zoom_level,
               :default_base_map,
               :saved,
               :published,
               :slug,
               :user_id,
               :owner,
               :raster_layer_project_ids,
               :vector_layer_project_ids,
               :mine,
               :may_edit,
               :user_ids,
               :featured,
               :intro,
               :media,
               :photo,
               :templateSlug,
               :template_id

    def mine
        instance_options[:mine]
    end

    def may_edit
        instance_options[:may_edit]
    end

    def card_url
        return object.card.url
    end

    def card_phone_url
        return object.card.phone.url
    end

    def card_tablet_url
        return object.card.tablet.url
    end
end
