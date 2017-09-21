# Model class for vector layers.
class VectorLayer < ApplicationRecord
    # Use Set to determine the types of features.
    require 'set'

    has_many :vector_layer_project
    has_many :projects, through: :vector_layer_project, dependent: :destroy
    has_many :vector_feature
    belongs_to :institution

    before_create :ensure_name
    # after_create :calculate_boundingbox_on_create
    before_save :calculate_boundingbox
    before_save :find_data_type

    # Uses `acts-as-taggable-on` gem.
    acts_as_taggable

    scope :by_institution, ->(institution) { joins(:institution).where(institutions: { name: institution }) if institution.present? }

    # Uses `acts-as-taggable-on` gem.
    scope :by_tags, ->(tags) { tagged_with(tags, any: true, wild: true) if tags.present? }
    scope :search_by_year, ->(start_year, end_year) { where(year: start_year..end_year) }
    scope :text_search, ->(_text_search) { joins(:text_search) if query.present? }
    scope :active, -> { where(active: true) }
    scope :alpha_sort, -> { order('title ASC') }
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
                        },
                        vector_feature: {
                            properties: 'C'
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

    def filters
        return if vector_feature.empty?
        return unless vector_feature.first.properties['filters']
        return if vector_feature.first.properties['filters'].empty?
        filter_values = vector_feature.map { |f| f.properties['filters'].values }.uniq!.flatten
        filter_key = vector_feature.map { |f| f.properties['filters'].keys }.uniq!.flatten[0]
        return { filter_key => filter_values }
        # vector_feature.first.properties['filters']
    end

    def ensure_name
        # Name is the persistant unique identifier. We have to have one.
        self.name = SecureRandom.hex(4) if name.nil?
    end

    private

    def find_data_type
        types = vector_feature.pluck(:geometry_type).uniq
        self.data_type = if types.length == 1
                             types[0]
                         else
                             'GeometryCollection'
                         end
    end

    def calculate_boundingbox
        # Don't bother if the layer has no features.
        return unless vector_feature.length > 1
        # We use the `union` method from RGeo to combine all the
        # features. We get the first feature so we have something to
        # on which to call `union`.
        group = vector_feature[0].geometry_collection
        vector_feature.drop(1).each do |vf|
            group = group.union(vf.geometry_collection)
        end
        self.boundingbox = group.envelope
        factory = RGeo::Geographic.simple_mercator_factory.projection_factory
        bb = RGeo::Cartesian::BoundingBox.create_from_geometry(factory.collection([boundingbox]))
        self.maxx = bb.max_x
        self.maxy = bb.max_y
        self.minx = bb.min_x
        self.miny = bb.min_y
    end
end
