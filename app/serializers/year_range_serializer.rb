class YearRangeSerializer < ActiveModel::Serializer
    attributes :id, :min_year, :max_year
end
