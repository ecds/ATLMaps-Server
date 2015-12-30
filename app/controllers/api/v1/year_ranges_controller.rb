class Api::V1::YearRangesController < ApplicationController

  def show
    range = YearRange.new()
    render json: range
  end
end
