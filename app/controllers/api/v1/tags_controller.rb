class Api::V1::TagsController < ApplicationController
  def index
    @tags = Tag.all.order('name')
    render json: @tags, root: 'tags'
  end

  def show
    @tag = Tag.find(params[:id])
    render json: @tag, root: 'tag'
  end
end
