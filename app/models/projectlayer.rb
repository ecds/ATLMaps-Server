class Projectlayer < ApplicationRecord
    belongs_to :project

    default_scope { order('position DESC') }
end
