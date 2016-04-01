class RasterLayerSerializer < ActiveModel::Serializer

  # ActiveModel::Serializer.config.adapter = :json

  #embed :ids # this is key for the Ember data to work.

  # has_many :projects, embed: :ids
  # has_many :tags, embed: :ids
  #has_many :projectlayer
  has_one :institution
  belongs_to :raster_layer_project

  attributes  :id,
              :name,
              :title,
              :slug,
              :keywords,
              :description,
              :workspace,
              :date,
              :year,
              :data_format,
              :data_type,
              :minzoom,
              :maxzoom,
              :minx,
              :miny,
              :maxx,
              :maxy,
              :institution,
              :tag_slugs,
              :active,
              :tag_ids,
              :project_ids,
            #   :active_in_project,
              :slider_id,
              :slider_value_id,
              :tag_ids
            #   :position_in_project

	# def active_in_project
	# 	return true
	# end

  # Not getting this to Ember
  # def position_in_project
  #   relation_to_project = RasterLayerProject.where(project_id: options[:project_id].to_i, raster_layer_id: self.id).first
  #
  #   if relation_to_project.nil?
  #       return 0
  #   else
  #     return relation_to_project.position
  #   end
  # end

end
