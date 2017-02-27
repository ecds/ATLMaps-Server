class Layer < ActiveRecord::Base
    # include Filtering
    has_many :projectlayer
    has_many :projects, through: :projectlayer, dependent: :destroy
    has_many :user_taggeds, dependent: :destroy
    belongs_to :institution

    has_and_belongs_to_many :tags, dependent: :destroy

    attributes :slider_id

    # Attribute to use for html classes
    def tag_slugs
        return tags.map { |tag| tag.name.parameterize }.join(' ')
    end
end
