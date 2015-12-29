class Api::V1::YearRangesController < ApplicationController
  def index
    @range = {
      :year_range => {
        min_year: [RasterLayer.minimum(:year), VectorLayer.minimum(:year)].min,
        max_year: [RasterLayer.maximum(:year), VectorLayer.maximum(:year)].max,
        id: 1
      }
    }

    render json: @range
  end
end
