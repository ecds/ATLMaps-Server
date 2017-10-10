# app/models/tag.rb
class Tag < ApplicationRecord
    has_many :categories_tags
    has_many :categories, through: :categories_tags
    # Assotiations are handled by acts-as-taggable-on gem
    def slug
        name.parameterize
    end
end
