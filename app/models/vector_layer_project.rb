# frozen_string_literal: true

#
# Model class for the relationship between a VectorLayer and a Project.
#
class VectorLayerProject < ApplicationRecord
  belongs_to :vector_layer
  belongs_to :project

  before_save :set_color_map, :set_order

  #
  # Provide the related `VectorLayer`'s data type so the client
  # can easily filter.
  #
  # @return [String] data type of `VectorLayer` qualitative or quantitative
  #
  def data_type
    vector_layer.data_type
  end

  # private

  #
  # Chuncks the data based on the the number to steps given
  # and assings color from the Colorbrewer scheme.
  #
  # Example:
  # [
  #   {top: 11229356, color: "#f7f4f9", bottom: 688232},
  #   {top: 21770481, color: "#e7e1ef", bottom: 11229357},
  #   {top: 32311606, color: "#d4b9da", bottom: 21770482},
  #   {top: 42852731, color: "#c994c7", bottom: 32311607},
  #   {top: 53393856, color: "#df65b0", bottom: 42852732}
  # ]
  #
  # @return [Hash] see example
  #
  def set_color_map
    self.marker = nil if color_map.present?
    return if property.nil? || steps.nil? || brewer_scheme.nil? || vector_layer.qualitative?

    # random brewer scheme
    # ColorBrewer.new.brew.to_a.sample(1).to_h.keys.first.to_s

    return unless vector_layer.geojson['features'].first['properties'][property].is_a?(Numeric)

    min = vector_layer.geojson['features']
                      .map { |feature| feature['properties'][property] }
                      .min.floor

    max = vector_layer.geojson['features']
                      .map { |feature| feature['properties'][property] }
                      .max.ceil

    range = min..max

    groups = slice_data(range)

    self.marker = nil
    self.color_map = groups.flatten.delete_if { |g| g.is_a?(Integer) }
  end

  #
  # Slices the range of data values and matches them up
  # with the apporiate color.
  #
  # @param [Range] range Range of max and min for
  # the data property being used for steps.
  #
  # @return [Array] Array of Hashes
  #
  def slice_data(range)
    range.each_slice(range.max / steps)
         .with_index
         .with_object({}) do |(step, index), group|
           group[index] = {
             bottom: step.first,
             top: step.last,
             color: offset_color(index)
           }
         end
  end

  #
  # The colors in a ColorBrewer scheme (sequential and diverging)
  # are darker at the end. This selectes the darkest color possiable
  # from the sheme.
  #
  # @param [Intiger] index index of step in color_map
  #
  # @return [String] hex value of color
  #
  def offset_color(index)
    cb_scheme = ColorBrewer.new.brew[brewer_scheme.to_sym]
    scheme_count = cb_scheme.length
    offset = scheme_count + index - steps
    cb_scheme[offset]
  end

  #
  # Set order based on number of data layers
  # already added to the project.
  #
  # @return [Intiger] placement of layer in project.
  #
  def set_order
    return if project.nil?

    self.order =
      if project.vector_layers.empty?
        1
      elsif project.vector_layer_project.map(&:order).min > 1
        project.vector_layer_project.map(&:order).min - 1
      else
        project.vector_layers.count + 1
      end
  end
end
