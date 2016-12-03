# app/serializers/project_serializer.rb
class ProjectSerializer < ActiveModel::Serializer

  # ActiveModel::Serializer.config.adapter = :json
  # has_many :raster_layers, embed: :objects
  # has_many :vector_layers, embed: :ids
  # has_many :raster_layer_project, embed: :objects#, :include => true
  # has_many :raster_layer_project, embed: :ids
  # has_many :vector_layer_project, embed: :ids
  # has_many :users, embed: :ids


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
            #  :user,
             :owner,
             :raster_layer_project_ids,
             :vector_layer_project_ids,
            #  :raster_layer_project,
            #  :raster_layer_ids,
            #  :vector_layer_ids,
             :is_mine,
             :may_edit,
             :user_ids,
             :featured,
             :intro,
             :media,
             :photo,
             :templateSlug,
             :template_id,
            #  :card_url,
            #  :card_phone_url,
            #  :card_tablet_url

  def is_mine()
    return instance_options[:resource_owner] == object.user_id.to_i
  end

  def card_url()
      return object.card.url
  end

  def card_phone_url()
      return object.card.phone.url
  end

  def card_tablet_url()
      return object.card.tablet.url
  end

  def may_edit
    if object.user_ids.include? instance_options[:resource_owner]
      return true
    else
      return is_mine
    end
  end
end
