# frozen_string_literal: true

# app/models/categories_tag.rb
class CategoriesTag < ApplicationRecord
  belongs_to :category
  belongs_to :tag
end
