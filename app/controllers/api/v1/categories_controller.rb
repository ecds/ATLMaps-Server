class Api::V1::CategoriesController < ApplicationController
    def index
      @categories = Category.all.order('name')
      render json: @categories, root: 'categories'
    end

    def show
      @category = Category.find(params[:id])
      render json: @category, root: 'category'
    end
end
