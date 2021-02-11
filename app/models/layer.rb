# frozen_string_literal: true

#
# Base Class for layer models
#
class Layer < ApplicationRecord
  include PgSearch::Model
  include Sanitize

  before_validation :sanitize_data

  before_save :calculate_boundingbox

  acts_as_taggable
  belongs_to :institution

  self.abstract_class = true

  scope :by_institution, ->(institution) { joins(:institution).where(institutions: { name: institution }) if institution.present? }
  scope :active, -> { where(active: true) }
  scope :alpha_sort, -> { order('title ASC') }
  scope :by_tags, ->(tags) { tagged_with(tags, any: true, wild: true) if tags.present? }
  # scope :by_year, ->(start_year, end_year) { where(year: start_year..end_year) }
  scope :text_search, ->(_text_search) { joins(:text_search) if query.present? }

  #
  # Filter layers by year range. Not yet used
  #
  # @param [Date] start_year <description>
  # @param [Date] end_year <description>
  #
  # @return [Layer] layers filterd by years
  #
  def self.by_year(start_year, end_year)
    if end_year.positive?
      search_by_year(start_year, end_year)
    else
      all
    end
  end

  # Scope for weighting full text search.
  pg_search_scope :search,
                  against: {
                    name: 'A',
                    title: 'A',
                    description: 'C',
                    keywords: 'C',
                    attribution: 'D'
                  },
                  associated_against: {
                    tags: {
                      name: 'B'
                    }
                  },
                  using: {
                    tsearch: {
                      prefix: true, dictionary: 'english'
                    }
                  }

  #
  # Full text search. This is needed to return all results
  # if no query string is provided. The controllers do not
  # conditionally call this method. Otherwise, no results
  # will be returned.
  #
  # @param [String] query Text to search
  #
  # @return [Layer::ActiveRecord_Relation] Full text search results
  #
  def self.browse_text_search(query)
    return search(query) if query.present?

    all
  end

  scope :spatial_lucene,
        lambda { |params|
          return if params[:bounds].nil?

          distance_from_center = Arel::Nodes::Grouping.new(
            Arel::Nodes::Addition.new(
              Arel::Nodes::NamedFunction.new(
                'ST_DISTANCE',
                [
                  Arel::Nodes::NamedFunction.new(
                    'ST_Centroid', [Arel::Nodes::Quoted.new(params[:bounds])]
                  ),
                  arel_table[:boundingbox].st_centroid
                ]
              ),
              1
            )
          )
          # http://svn.code.sf.net/p/geoportal/code/Geoportal/trunk/src/com/esri/gpt/catalog/lucene/SpatialRankingValueSource.java
          # double intersectionArea = width * height;
          # double queryRatio  = intersectionArea / this.qryArea;
          # double targetRatio = intersectionArea / tgtArea;
          # double queryFactor  = Math.pow(queryRatio,this.qryPower);
          # double targetFactor = Math.pow(targetRatio,this.tgtPower);
          # score = queryFactor * targetFactor * 10000.0;
          query_ratio = Arel::Nodes::Division.new(
            Arel::Nodes::NamedFunction.new(
              'ST_Area',
              [
                arel_table[:boundingbox].st_intersection(Arel::Nodes::Quoted.new(params[:bounds])),
                Arel::Nodes::SqlLiteral.new('false') # set `use_spheroid` to false. There should be a better way to do this.
              ]
            ),
            Arel::Nodes::Quoted.new(params[:bounds].area)
          )

          target_ratio = Arel::Nodes::Division.new(
            Arel::Nodes::NamedFunction.new(
              'ST_Area',
              [
                arel_table[:boundingbox].st_intersection(Arel::Nodes::Quoted.new(params[:bounds])),
                # set `use_spheroid` to false. There should be a better way to do this.
                Arel::Nodes::SqlLiteral.new('false')
              ]
            ),
            Arel::Nodes::NamedFunction.new(
              'ST_Area',
              [
                arel_table[:boundingbox],
                # set `use_spheroid` to false. There should be a better way to do this.
                Arel::Nodes::SqlLiteral.new('false')
              ]
            )
          )

          lucene_score = Arel::Nodes::Division.new(
            Arel::Nodes::Multiplication.new(
              target_ratio,
              query_ratio
            ),
            distance_from_center
            # 10_000
          )

          select(
            [
              arel_table[Arel.star]
            ]
          ).where(
            Arel::Nodes::NamedFunction.new(
              'ST_INTERSECTS',
              [
                arel_table[:boundingbox],
                Arel::Nodes::Quoted.new(params[:bounds])
              ]
            )
          ).order(lucene_score.desc)
        }

  private

  def calculate_boundingbox
    raise StandardError.new('calculate_bounding_box must be overridden.')
  end

  #
  # Remove any unnessary HTML tags from the description
  #
  # @return [String] clean HTML string
  #
  def sanitize_data
    self.description = sanitize_value(description)
  end

  # scope :by_neighborhood,
  #       lambda {
  #         intersection = Arel::Nodes::NamedFunction.new(
  #           'ST_AREA',
  #           [
  #             Arel::Nodes::NamedFunction.new(
  #               'ST_INTERSECTION',
  #               [
  #                 arel_table[:boundingbox],
  #                 Neighborhood.arel_table[:polygon]
  #               ]
  #             )
  #           ]
  #         )

  #         distance_from_center = Arel::Nodes::NamedFunction.new(
  #           'ST_DISTANCE',
  #           [
  #             Arel::Nodes::NamedFunction.new(
  #               'ST_Centroid', [Neighborhood.arel_table[:polygon]]
  #             ),
  #             Arel::Nodes::NamedFunction.new(
  #               'ST_Centroid', [arel_table[:boundingbox]]
  #             )
  #           ]
  #         )

  #         RasterLayer.select(
  #           [
  #             arel_table[:title],
  #             Neighborhood.arel_table[:name],
  #             intersection,
  #             distance_from_center
  #           ]
  #         ).joins(
  #           arel_table.join(Neighborhood.arel_table).on(
  #             Arel::Nodes::NamedFunction.new(
  #               'ST_INTERSECTS',
  #               [
  #                 arel_table[:boundingbox],
  #                 Neighborhood.arel_table[:polygon]
  #               ]
  #             )
  #           ).join_sources
  #         ).order(
  #           Neighborhood.arel_table[:name],
  #           distance_from_center,
  #           intersection.desc
  #         )
  #       }
end
