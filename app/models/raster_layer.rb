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
class RasterLayer < ActiveRecord::Base
  require 'bigdecimal'
  include PgSearch

  has_many :raster_layer_project
  has_many :projects, through: :raster_layer_project, dependent: :destroy
  has_many :user_taggeds
  belongs_to :institution

  has_and_belongs_to_many :tags, dependent: :destroy

  # Scope: by_institution. Seraches layers by institution
  scope :by_institution, ->(institution) { joins(:institution).where(institutions: {name: institution}) if institution.present?}
  scope :by_tags, -> tags { joins(:tags).where(tags: {name: tags}) if tags.present?}
  scope :search_by_year, -> (start_year,end_year) { where(year: start_year..end_year) }

  # @!method search_by_year(yyyy, yyyy)
  # @param [Integer] start_year, four digit year for lower bound search.
  # @param [Integer] end_year, for digit year for upper bound of search
  # Validates the incoming parameters and calls the `by_year` scope.
  # @todo This works, but should it be returning something?
  def self.by_year(start_year, end_year)
      if end_year > 0
          search_by_year(start_year, end_year)
      else
          all
      end
  end
  # scope :text_search, ->(text_search) { joins(:text_search) if text_search.present?}
  scope :active, -> { where(active: true)}
  # Get random map taht has less than three tags
  scope :test, -> { all if :tags.length > 0 }
  scope :un_tagged, -> { group("raster_layers.id").having( 'count( raster_layers ) < 3' ).order('RANDOM()') }

  pg_search_scope :search, against: [:name, :title, :description],
    using: { tsearch: { prefix: true, dictionary: 'english' } }
    # associated_against: { tags: :name, institution: :name }

  def self.text_search(query)
      # Return no results if query isn't present
      search(query)
  end

  def self.browse_text_search(query)
      # If there is no query, return everything.
      # Not everything will be returned becuae other filters will be present.
    if query.present?
      search(query)
    else
      all
    end
  end

  # SELECT raster_layers.title, neighborhoods.name
  # FROM raster_layers INNER JOIN neighborhoods
  # ON  st_intersects(boundingbox, neighborhoods.polygon )
  # {st_intersects(:boundingbox, poly)}
  # scope :by_bounds, -> (bounds) { where{st_intersects(:boundingbox, bounds)} if bounds.present? }
  scope :by_bounds, -> bounds {
    intersection = Arel::Nodes::NamedFunction.new(
      'ST_AREA', [
        Arel::Nodes::NamedFunction.new(
          'ST_INTERSECTION', [
            RasterLayer.arel_table[:boundingbox], Arel::Nodes::Quoted.new(bounds)
          ]
        )
      ]
    )

    distance_from_center = Arel::Nodes::NamedFunction.new(
      'ST_DISTANCE', [
        Arel::Nodes::NamedFunction.new(
          'ST_Centroid', [Arel::Nodes::Quoted.new(bounds)]
        ), Arel::Nodes::NamedFunction.new(
          'ST_Centroid', [RasterLayer.arel_table[:boundingbox]]
        )
      ]
    )

    RasterLayer.select( [
      RasterLayer.arel_table[Arel.star]
    ]).where(
    Arel::Nodes::NamedFunction.new(
      'ST_INTERSECTS', [
        RasterLayer.arel_table[:boundingbox], Arel::Nodes::Quoted.new(bounds)
      ]
    )
    ).order(
      distance_from_center, intersection.desc
    )
  }

  scope :by_neighborhood, -> {
    intersection = Arel::Nodes::NamedFunction.new(
      'ST_AREA', [
        Arel::Nodes::NamedFunction.new(
          'ST_INTERSECTION', [
            RasterLayer.arel_table[:boundingbox], Neighborhood.arel_table[:polygon]
          ]
        )
      ]
    )

    distance_from_center = Arel::Nodes::NamedFunction.new(
      'ST_DISTANCE', [
        Arel::Nodes::NamedFunction.new(
          'ST_Centroid', [Neighborhood.arel_table[:polygon]]
        ), Arel::Nodes::NamedFunction.new(
          'ST_Centroid', [RasterLayer.arel_table[:boundingbox]]
        )
      ]
    )

    RasterLayer.select(
      [
        RasterLayer.arel_table[:title], Neighborhood.arel_table[:name], intersection, distance_from_center
      ]
    ).joins(
      RasterLayer.arel_table.join(Neighborhood.arel_table).on(
        Arel::Nodes::NamedFunction.new(
          'ST_INTERSECTS', [
            RasterLayer.arel_table[:boundingbox], Neighborhood.arel_table[:polygon]
          ]
        )
      ).join_sources
    ).order(
      Neighborhood.arel_table[:name], distance_from_center, intersection.desc
    )
  }




# RasterLayer.joins{st_intersects(:boundingbox, :neighborhoods) :neighborhoods}.select{st_area(st_intersection(:boundingbox, neighborhoods.polygon)).as('intersection')}
#
# RasterLayer.includes(:neighborhoods).select{[st_area(st_intersection(:boundingbox, :neighborhoods.polygon)).as('intersection'), st_distance(st_centroid(:boundingbox), st_centroid(n.polygon)).as('distance')]}

# RasterLayer.select{[
#   st_area(
#     st_intersection(:boundingbox, n.polygon)
#   ).as('intersection'),
#   st_distance(
#     st_centroid(:boundingbox),
#     st_centroid(n.polygon)
#   ).as('distance')]
# }.joins{neighborhoods}

# SELECT
#   raster_layers.title,
#   neighborhoods.name,
# ST_AREA(ST_INTERSECTION(
#     raster_layers.boundingbox,
#     neighborhoods.polygon)
# ) AS intersection,
# ST_DISTANCE(
#     ST_Centroid(
#         neighborhoods.polygon
#     ),
#     ST_Centroid(
#         raster_layers.boundingbox)
#     ) AS distance_from_center
# FROM raster_layers INNER JOIN neighborhoods
# ON  ST_INTERSECTS(
#     raster_layers.boundingbox,
#     neighborhoods.polygon
# )
# WHERE neighborhoods.id = 37
# ORDER BY
#     distance_from_center ASC,
#     intersection DESC

  # before_save :set_boundingbox

# conf.echo = false
# ActiveRecord::Base.logger = nil




  # def self.browse_text_search(query)
  #     # If there is no query, return everything.
  #     # Not everything will be returned becuae other filters will be present.
  #   if query.present?
  #     search(query)
  #   else
  #     all
  #   end
  # end


  # Attribute to use for html classes
  def slug
  	slug = self.name.parameterize
  	return "#{slug}-#{id}"
  end

  # TODO: Is this needed anymore?
  # Attribute to provide an array tag slugs.
  def tag_slugs
    return self.tags.map {|tag| tag.name.parameterize}.join(" ")
  end

  # @!attribute [r] slider_id
  # @return [String]
  # Attribute used to make unique identifer for the front end opacity slider.
  def slider_id
  	slug = self.name.parameterize
  	return "slider-#{slug}-#{id}"
  end

  # @!attribute [r] slider_value_id
  # @return [String]
  # TODO: Is this needed anymore?
  def slider_value_id
  	slug = self.name.parameterize
  	return "slider-value-#{slug}-#{id}"
  end

  # @!attribute [r] url
  # @return [String]
  # Convience attribute to the GeoServer endpoint
  def url
      return "#{self.institution.geoserver}#{self.workspace}/wms"
  end

  def set_boundingbox(raster)
    factory = RGeo::Geographic.simple_mercator_factory()
    nw = factory.point(raster.maxx, raster.maxy)
    ne = factory.point(raster.minx, raster.maxy)
    se = factory.point(raster.minx, raster.miny)
    sw = factory.point(raster.maxx, raster.miny)
    return factory.polygon(
      factory.linear_ring([nw, ne, se, sw, nw])
    )
  end

  # @!attribute [r] layers
  # @return [String]
  # Convience attribute. Used in WMS call.
  def layers
      return "#{self.workspace}:#{self.name}"
  end
end
