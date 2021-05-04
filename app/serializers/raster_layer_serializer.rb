# frozen_string_literal: true

class RasterLayerSerializer < LayerSerializer
  include Rails.application.routes.url_helpers
  attributes :workspace, :layers, :thumb_url

  #
  # URL for ActiveStorage object
  #
  # @return [String] <description>
  #
  def thumb_url
    if object.thumbnail.attached?
      return Rails.application.routes.url_helpers.rails_blob_url(object.thumbnail)
      # variant = object.thumbnail.variant(resize: '100x100')
      # file = rails_representation_url(variant, only_path: true).to_s
      # return "#{ENV['ROOT_URL']}#{file}"
    end
    nil
  end
end
