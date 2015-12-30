class YearRangeSerializer < ActiveModel::Serializer

  ActiveModel::Serializer.config.adapter = :json

  attributes  :id, :min_year, :max_year
end
