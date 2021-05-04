# frozen_string_literal: true

class Projectlayer < ApplicationRecord
  belongs_to :project

  default_scope { order('position DESC') }
end
