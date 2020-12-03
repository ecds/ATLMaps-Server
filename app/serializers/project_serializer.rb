# frozen_string_literal: true

# app/serializers/project_serializer.rb
class ProjectSerializer < ActiveModel::Serializer
  has_many :raster_layer_project
  has_many :vector_layer_project, serializer: VectorLayerProjectSerializer
  has_many :raster_layers
  has_many :vector_layers, serializer: VectorLayerSerializer
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
             :owner,
             :mine,
             :may_edit,
             :featured,
             :intro,
             :media,
             :photo

  def mine
    instance_options[:mine]
  end

  def may_edit
    instance_options[:may_edit]
  end
end
