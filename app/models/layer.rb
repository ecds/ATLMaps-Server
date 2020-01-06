class Layer < ApplicationRecord

  include PgSearch::Model

  acts_as_taggable
  belongs_to :institution

  self.abstract_class = true
  scope :by_institution, ->(institution) { joins(:institution).where(institutions: { name: institution }) if institution.present? }
  scope :active, -> { where(active: true) }
  scope :alpha_sort, -> { order('title ASC') }
  scope :by_tags, ->(tags) { tagged_with(tags, any: true, wild: true) if tags.present? }
  # scope :by_year, ->(start_year, end_year) { where(year: start_year..end_year) }
  scope :text_search, ->(_text_search) { joins(:text_search) if query.present? }
  def self.by_year(start_year, end_year)
    if end_year > 0
        search_by_year(start_year, end_year)
    else
        all
    end
  end

  pg_search_scope :search,
                  against: {
                    name: 'A',
                    title: 'A',
                    description: 'C',
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

  scope :raster_lucene, lambda { |params|
    if params[:bounds].present?
      distance_from_center = Arel::Nodes::Grouping.new(
        Arel::Nodes::Addition.new(
          Arel::Nodes::NamedFunction.new(
            'ST_DISTANCE', [
              Arel::Nodes::NamedFunction.new(
                'ST_Centroid', [Arel::Nodes::Quoted.new(params[:bounds])]
              ),
              RasterLayer.arel_table[:boundingbox].st_centroid
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
          'ST_Area', [
            RasterLayer.arel_table[:boundingbox].st_intersection(Arel::Nodes::Quoted.new(params[:bounds])),
            Arel::Nodes::SqlLiteral.new('false') # set `use_spheroid` to false. There should be a better way to do this.
          ]
        ),
        Arel::Nodes::Quoted.new(params[:bounds].area)
      )

      target_ratio = Arel::Nodes::Division.new(
        Arel::Nodes::NamedFunction.new(
          'ST_Area', [
            RasterLayer.arel_table[:boundingbox].st_intersection(Arel::Nodes::Quoted.new(params[:bounds])),
            Arel::Nodes::SqlLiteral.new('false') # set `use_spheroid` to false. There should be a better way to do this.
          ]
        ),
        Arel::Nodes::NamedFunction.new(
          'ST_Area', [
            RasterLayer.arel_table[:boundingbox],
            Arel::Nodes::SqlLiteral.new('false') # set `use_spheroid` to false. There should be a better way to do this.
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
          RasterLayer.arel_table[Arel.star]
        ]
      ).where(
        Arel::Nodes::NamedFunction.new(
          'ST_INTERSECTS', [
            RasterLayer.arel_table[:boundingbox],
            Arel::Nodes::Quoted.new(params[:bounds])
          ]
        )
      ).order(lucene_score.desc)
    end
  }

  scope :vector_lucene, lambda { |params|
    if params[:bounds].present?
      distance_from_center = Arel::Nodes::Grouping.new(
        Arel::Nodes::Addition.new(
          Arel::Nodes::NamedFunction.new(
            'ST_DISTANCE', [
              Arel::Nodes::NamedFunction.new(
                'ST_Centroid', [Arel::Nodes::Quoted.new(params[:bounds])]
              ),
              VectorLayer.arel_table[:boundingbox].st_centroid
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
          'ST_Area', [
            VectorLayer.arel_table[:boundingbox].st_intersection(Arel::Nodes::Quoted.new(params[:bounds])),
            Arel::Nodes::SqlLiteral.new('false') # set `use_spheroid` to false. There should be a better way to do this.
          ]
        ),
        Arel::Nodes::Quoted.new(params[:bounds].area)
      )

      target_ratio = Arel::Nodes::Division.new(
        Arel::Nodes::NamedFunction.new(
          'ST_Area', [
            VectorLayer.arel_table[:boundingbox].st_intersection(Arel::Nodes::Quoted.new(params[:bounds])),
            Arel::Nodes::SqlLiteral.new('false') # set `use_spheroid` to false. There should be a better way to do this.
          ]
        ),
        Arel::Nodes::NamedFunction.new(
          'ST_Area', [
            VectorLayer.arel_table[:boundingbox],
            Arel::Nodes::SqlLiteral.new('false') # set `use_spheroid` to false. There should be a better way to do this.
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
          VectorLayer.arel_table[Arel.star]
        ]
      ).where(
        Arel::Nodes::NamedFunction.new(
          'ST_INTERSECTS', [
            VectorLayer.arel_table[:boundingbox],
            Arel::Nodes::Quoted.new(params[:bounds])
          ]
        )
      ).order(lucene_score.desc)
    end
  }
end
