# frozen_string_literal: true

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
class ColorMap
  #
  # <Description>
  #
  # @param [<Type>] geojson <description>
  # @param [<Type>] property <description>
  # @param [<Type>] brewer_scheme <description>
  # @param [<Type>] steps <description>
  #
  def initialize(geojson:, property:, brewer_scheme: nil, steps: 5)
    @geojson = geojson
    @property = property
    @brewer_scheme = brewer_scheme.nil? ? random_brew : brewer_scheme
    @steps = steps

    validate!

    @range = calculate_range

    @groups = slice_data
  end

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
  def create_map
    @groups.flatten.delete_if { |g| g.is_a?(Integer) }
  end

  # private

  def calculate_range
    min = @geojson['features']
          .map { |feature| Float(feature['properties'][@property]) if feature['properties'][@property].present? }
          .compact(&:nil?)
          .min
          .floor

    max = @geojson['features']
          .map { |feature| Float(feature['properties'][@property]) if feature['properties'][@property].present? }
          .compact(&:nil?)
          .max
          .ceil

    return min..max
  end

  def random_brew
    ColorBrewer.new.brew.to_a[0..18].sample(1).to_h.keys.first.to_s if @brewer_scheme.nil?
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
  def slice_data
    @range = Float(@range.min)..Float(@range.max)
    range_steps = (@range.max - @range.min) / @steps
    breaks = []
    groups = []
    @range.step(range_steps) { |step| breaks.push(step) }
    breaks.map.with_index do |group, index|
      top = group.equal?(breaks.last) ? @range.max : breaks[index + 1] - 0.0001
      groups.push(
        {
          bottom: group.round(4),
          top: top.round(4),
          color: offset_color(index)
        }.with_indifferent_access
      )
    end
    if groups.count > @steps
      groups.pop
      groups.last[:top] = @range.max
    end
    groups
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
    cb_scheme = ColorBrewer.new.brew[@brewer_scheme.to_sym]
    scheme_count = cb_scheme.length
    offset = scheme_count + index - @steps
    cb_scheme[offset]
  end

  def validate!
    raise(ArgumentError, 'geojosn MUST be a Hash.') unless @geojson.is_a?(Hash)
    raise(ArgumentError, 'geojson MUST be valid GeoJSON.') unless @geojson[:features].is_a?(Array)
    raise(ArgumentError, "At lest one feature is missing a value for #{@property}") unless @geojson[:features].map { |f| Float(f[:properties][@property.to_sym]) }.any?(nil?)
    raise(ArgumentError, 'All values of the break property must be a Numeric') unless @geojson[:features].map { |f| Float(f[:properties][@property.to_sym]) }.any?(Numeric)
    raise(ArgumentError, 'Steps property must be a Numeric') unless Float(@steps).is_a?(Numeric)
  end
end
