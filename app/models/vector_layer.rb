# Model class for vector layers.
class VectorLayer < ActiveRecord::Base
    # FIXME: This is temp until we decide on a better admin solution.
    # before_create :defaults
    # after_create :load_features

    # include Filtering
    has_many :vector_layer_project
    has_many :projects, through: :vector_layer_project, dependent: :destroy
    has_many :vector_feature
    belongs_to :institution

    # Uses `acts-as-taggable-on` gem.
    acts_as_taggable

    scope :by_institution, ->(institution) { joins(:institution).where(institutions: { name: institution }) if institution.present? }

    # Uses `acts-as-taggable-on` gem.
    scope :by_tags, ->(tags) { tagged_with(tags, any: true, wild: true) if tags.present? }
    scope :search_by_year, ->(start_year, end_year) { where(year: start_year..end_year) }
    scope :text_search, ->(_text_search) { joins(:text_search) if query.present? }
    scope :active, -> { where(active: true) }
    scope :by_bounds, lambda { |bounds|
        if bounds.present?
            intersection = Arel::Nodes::NamedFunction.new(
                'ST_AREA', [
                    Arel::Nodes::NamedFunction.new(
                        'ST_INTERSECTION', [
                            VectorLayer.arel_table[:boundingbox],
                            Arel::Nodes::Quoted.new(bounds)
                        ]
                    )
                ]
            )

            distance_from_center = Arel::Nodes::NamedFunction.new(
                'ST_DISTANCE', [
                    Arel::Nodes::NamedFunction.new(
                        'ST_Centroid', [Arel::Nodes::Quoted.new(bounds)]
                    ), Arel::Nodes::NamedFunction.new(
                        'ST_Centroid', [VectorLayer.arel_table[:boundingbox]]
                    )
                ]
            )

            # area_of_intersection = Arel::Nodes::NamedFunction.new(
            #     'ST_INTERSECTION', [
            #
            #     ]
            # )

            VectorLayer.select([
                                   VectorLayer.arel_table[Arel.star]
                               ]).where(
                                   Arel::Nodes::NamedFunction.new(
                                       'ST_INTERSECTS', [
                                           VectorLayer.arel_table[:boundingbox],
                                           Arel::Nodes::Quoted.new(bounds)
                                       ]
                                   )
                               ).order(
                                   distance_from_center, intersection.desc
                               )
        end
    }

    def self.by_year(start_year, end_year)
        if end_year > 0
            search_by_year(start_year, end_year)
        else
            all
        end
    end

    include PgSearch
    pg_search_scope :search,
                    against: {
                        name: 'A',
                        title: 'A',
                        description: 'C'
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

    # Attribute to use for html classes
    def slug
        slug = title.parameterize
        return "#{slug}-#{id}"
    end

    def tag_slugs
        return tags.map { |tag| tag.name.parameterize }.join(' ')
    end

    def defaults
        self.institution = Institution.find(1)
        self.data_type = 'point-data'
        self.data_format = 'vector'
        self.active = true
        self.name = (0...8).map { (65 + rand(26)).chr }.join.downcase
    end

    # @!attribute [r] slider_id
    # @return [String]
    # Attribute used to make unique identifer for the front end opacity slider.
    def slider_id
        slug = name.parameterize
        return "slider-#{slug}-#{id}"
    end
end

# def depth (a)
#   return 0 unless a.is_a?(Array)
#   return 1 + depth(a[0])
# end
#
# def depth (a)
#   return 0 unless a.is_a?(Array)
#   return 1 + depth(a[0])
# end
