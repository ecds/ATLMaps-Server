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
class RasterLayer < ApplicationRecord
    include PgSearch
    HTTParty::Basement.default_options.update(verify: false)
    mount_uploader :thumb, RasterThumbnailUploader

    has_many :raster_layer_project
    has_many :projects, through: :raster_layer_project, dependent: :destroy
    has_many :user_taggeds
    belongs_to :institution

    # Uses `acts-as-taggable-on` gem.
    acts_as_taggable

    # before_save :create_thumbnail
    before_save :calculate_boundingbox

    # Scope: by_institution. Seraches layers by institution
    scope :by_institution, lambda { |institution|
        joins(:institution).where(institutions: { name: institution }) \
        if institution.present?
    }

    # Uses `acts-as-taggable-on` gem.
    scope :by_tags, ->(tags) { tagged_with(tags, any: true, wild: true) if tags.present? }

    scope :search_by_year, lambda { |start_year, end_year|
        where(year: start_year..end_year)
    }

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

    scope :active, -> { where(active: true) }
    scope :alpha_sort, -> { order('title ASC') }

    # Get random map taht has less than three tags
    scope :test, -> { all unless :tags.empty? }
    scope :un_tagged, lambda {
        group('raster_layers.id')
            .having('count( raster_layers ) < 3')
            .order('RANDOM()').first
    }

    # TODO: For some reason, in test, the `associated_against` does not work.
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

    scope :by_bounds, lambda { |bounds|
        if bounds.present?
            # The area of the intersection of the viewable bounds and the bounds of a layer.
            intersection = Arel::Nodes::NamedFunction.new(
                'ST_AREA', [
                    Arel::Nodes::NamedFunction.new(
                        'ST_INTERSECTION', [
                            RasterLayer.arel_table[:boundingbox],
                            Arel::Nodes::Quoted.new(bounds)
                        ]
                    )
                ]
            )

            # The distance from the center of a layer and the center of the viewable area.
            distance_from_center = Arel::Nodes::NamedFunction.new(
                'ST_DISTANCE', [
                    Arel::Nodes::NamedFunction.new(
                        'ST_Centroid', [Arel::Nodes::Quoted.new(bounds)]
                    ), Arel::Nodes::NamedFunction.new(
                        'ST_Centroid', [RasterLayer.arel_table[:boundingbox]]
                    )
                ]
            )

            # Area of the viewable bounds.
            layer_bounding_box_area = Arel::Nodes::NamedFunction.new(
                'ST_AREA', [RasterLayer.arel_table[:boundingbox]]
            )

            # Area of the bounds to be searched.
            bounds_area = Arel::Nodes::NamedFunction.new(
                'ST_AREA', [Arel::Nodes::Quoted.new(bounds)]
            )

            diff_intersection_layer = Arel::Nodes::NamedFunction.new(
                'ABS', [
                    Arel::Nodes::Subtraction.new(
                        intersection,
                        layer_bounding_box_area
                    )
                ]
            )

            # Difference of the areas
            # We get the absolute value because we don't know if the minuend is greater than
            # or less than the summand.
            diff_areas = Arel::Nodes::NamedFunction.new(
                'ABS', [
                    Arel::Nodes::Subtraction.new(
                        bounds_area,
                        layer_bounding_box_area
                    )
                ]
            )

            # The score is:
            # area of the map minus the area of the intersection of the map and the searched bounds
            # plus the distance between the center of the the map and the searched bounds
            # plus the area of the map minus the area of the searched bounds
            score = Arel::Nodes::Addition.new(
                Arel::Nodes::Addition.new(
                    diff_intersection_layer,
                    distance_from_center
                ),
                diff_areas
            )

            RasterLayer.select([
                                   RasterLayer.arel_table[Arel.star]
                               ]).where(
                                   Arel::Nodes::NamedFunction.new(
                                       'ST_INTERSECTS', [
                                           RasterLayer.arel_table[:boundingbox],
                                           Arel::Nodes::Quoted.new(bounds)
                                       ]
                                   )
                               ).order(
                                   score
                               )
        end
    }

    scope :by_neighborhood, lambda {
        intersection = Arel::Nodes::NamedFunction.new(
            'ST_AREA', [
                Arel::Nodes::NamedFunction.new(
                    'ST_INTERSECTION', [
                        RasterLayer.arel_table[:boundingbox],
                        Neighborhood.arel_table[:polygon]
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
                RasterLayer.arel_table[:title], Neighborhood.arel_table[:name],
                intersection, distance_from_center
            ]
        ).joins(
            RasterLayer.arel_table.join(Neighborhood.arel_table).on(
                Arel::Nodes::NamedFunction.new(
                    'ST_INTERSECTS', [
                        RasterLayer.arel_table[:boundingbox],
                        Neighborhood.arel_table[:polygon]
                    ]
                )
            ).join_sources
        ).order(
            Neighborhood.arel_table[:name],
            distance_from_center,
            intersection.desc
        )
    }

    def area(bounds)
        return 'ST_DISTANCE', [
            Arel::Nodes::NamedFunction.new(
                'ST_Centroid', [Arel::Nodes::Quoted.new(bounds)]
            ), Arel::Nodes::NamedFunction.new(
                'ST_Centroid', [RasterLayer.arel_table[:boundingbox]]
            )
        ]
    end

    # Attribute to use for html classes
    def slug
        slug = name.parameterize
        return "#{slug}-#{id}"
    end

    # TODO: Is this needed anymore?
    # Attribute to provide an array tag slugs.
    def tag_slugs
        return tags.map { |tag| tag.name.parameterize }.join(' ')
    end

    # @!attribute [r] slider_id
    # @return [String]
    # Attribute used to make unique identifer for the front end opacity slider.
    def slider_id
        slug = name.parameterize
        return "slider-#{slug}-#{id}"
    end

    # @!attribute [r] slider_value_id
    # @return [String]
    # TODO: Is this needed anymore?
    def slider_value_id
        slug = name.parameterize
        return "slider-value-#{slug}-#{id}"
    end

    # @!attribute [r] url
    # @return [String]
    # Convience attribute to the GeoServer endpoint
    def url
        # return 'foo'
        return "#{institution.geoserver}#{workspace}/gwc/service/wms?tiled=true"
    end

    # @!attribute [r] layers
    # @return [String]
    # Convience attribute. Used in WMS call.
    def layers
        return "#{workspace}:#{name}"
    end

    def calculate_boundingbox
        factory = RGeo::Geographic.simple_mercator_factory.projection_factory
        self.boundingbox = factory.polygon(
            factory.line_string(
                [
                    factory.point(maxx, maxy),
                    factory.point(minx, maxy),
                    factory.point(minx, miny),
                    factory.point(maxx, miny),
                    factory.point(maxx, maxy)
                ]
            )
        )
    end

    private

    def create_thumbnail
        factory = RGeo::Geographic.simple_mercator_factory.projection_factory
        nw = factory.point(maxx, maxy)
        ne = factory.point(minx, maxy)
        se = factory.point(minx, miny)
        # 9.547 = Zoom level 14
        # http://wiki.openstreetmap.org/wiki/Zoom_levels
        height = (ne.distance(se) / 19.093).to_i
        width = (ne.distance(nw) / 19.093).to_i
        request = "#{institution.geoserver}#{workspace}/wms?service=WMS&version=1.1.0&request=GetMap&layers=#{workspace}:#{name}&styles=&bbox=#{minx},#{miny},#{maxx},#{maxy}&width=#{width}&height=#{height}&srs=EPSG:#{institution.srid}&format=image%2Fpng"
        response = nil
        filename = "/data/tmp/#{name}.png"
        File.open(filename, 'wb') do |file|
            response = HTTParty.get(request, stream_body: true) do |fragment|
                file.write(fragment)
            end
            self.thumb = file
            # file.delete
        end
    end
end
