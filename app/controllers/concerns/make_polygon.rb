# /lib/make_polygon.rb
module MakePolygon
    def make_polygon(bounds)
        return if bounds.nil?
        factory = RGeo::Geographic.simple_mercator_factory
        return factory.polygon(
            factory.linear_ring(
                [
                    factory.point(bounds[:w].to_d, bounds[:n].to_d),
                    factory.point(bounds[:e].to_d, bounds[:n].to_d),
                    factory.point(bounds[:e].to_d, bounds[:s].to_d),
                    factory.point(bounds[:w].to_d, bounds[:s].to_d),
                    factory.point(bounds[:w].to_d, bounds[:n].to_d)
                ]
            )
        )
    end
end
