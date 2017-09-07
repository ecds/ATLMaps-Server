class YearRange
    include ActiveModel::Model
    include ActiveModel::Serialization

    attr_accessor(:id, :min_year, :max_year)

    def id
        1
    end

    def min_year
        [RasterLayer.minimum(:year), VectorLayer.minimum(:year)].min
    end

    def max_year
        [RasterLayer.maximum(:year), VectorLayer.maximum(:year)].max
    end
end
