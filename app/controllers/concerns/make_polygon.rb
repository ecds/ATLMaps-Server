# /lib/make_polygon.rb
module MakePolygon
    def make_polygon(bounds)
        return if bounds.nil?
        factory = RGeo::Geographic.simple_mercator_factory
        return factory.polygon(
            factory.line_string(
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
    # bounds = make_polygon({:s=>33.77443867330882, :n=>33.76844992095692, :w=>-84.35952365398408, :e=>-84.3503075838089})
    # rs = RasterLayer.by_bounds(bounds: bounds)
end
