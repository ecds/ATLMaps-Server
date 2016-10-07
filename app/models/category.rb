# Model for Categories. Categories are used to organize `tags`.
class Category < ActiveRecord::Base
    # @association relatedObjs ['tags']
    # @todo can this just be an `has_many`?
    has_and_belongs_to_many :tags

    # @!attribute slug
    #   @return [String] parameterized version of of `category.name`.
    def slug
      self.name.parameterize
    end

end
