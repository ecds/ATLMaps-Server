class VectorLayerSerializer < ActiveModel::Serializer
  #embed :ids # this is key for the Ember data to work.
  
  has_many :projects, embed: :ids
  has_many :tags, embed: :ids
  has_many :projects
  has_one :institution
  
  attributes  :id,
              :name,
              :slug,
              :keywords,
              :description,
              :url,
              :layer,
              :date,
              :layer_type,
              :minzoom,
              :maxzoom,
              :minx,
              :miny,
              :maxx,
              :maxy,
              #:institution,
              :tag_slugs,
              :active,
              :tag_ids,
              :project_ids,
              :active_in_project,
              :project_ids

	def active_in_project
		if self.project_ids.include? options[:project_id].to_i
			return true
		else
			return false
		end
	end
end
