# frozen_string_literal: true

#
# <Description>
#
class VectorUpload
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include FixGeojsonFeature
  include Sanitize

  attr_accessor :type, :file, :attributes, :mapped_attributes, :geojson, :title, :file_name, :break_property

  #
  # <Description>
  #
  # @param [<Type>] attributes <description>
  # @option attributes [<Type>] :<key> <description>
  # @option attributes [<Type>] :<key> <description>
  # @option attributes [<Type>] :<key> <description>
  #
  def initialize(attributes = {})
    super

    raise(
      VectorUploadException, "File must be an instance of ActionDispatch::Http::UploadedFile. You pased a `#{file.class}`"
    ) unless file.instance_of?(ActionDispatch::Http::UploadedFile)

    accepted_types = %w(zip json geojson blob xlsx csv)
    set_type

    raise(VectorUploadException, "File must be of type #{accepted_types.join(', ')}") unless accepted_types.include?(type)

    unzip if type == 'zip'

    # set_file_name if title.present?

    self.break_property = mapped_attributes[:break] if mapped_attributes.present? && mapped_attributes[:break].present?
  end

  #
  # <Description>
  #
  # @return [<Type>] <description>
  #
  def set_type
    file_ext = file.original_filename.split('.').last
    self.type = file_ext
  end

  #
  # <Description>
  #
  # @return [<Type>] <description>
  #
  def set_attributes
    case type
    when 'zip'
      attributes_from_shape
    when 'xlsx', 'csv'
      attributes_from_spreadsheet
    else
      attributes_from_json
    end
  end

  #
  # <Description>
  #
  # @return [<Type>] <description>
  #
  def amend_attributes
    case type
    when 'xlsx', 'csv'
      return build_geojson
    else
      geojson = type == 'zip' ? to_geojson : file
      # TODO: Since we are no longer adding to GeoServer, we don't need to make a file on disk.
      json = JSON.parse(File.read(geojson)).with_indifferent_access
      json[:colorMap] = build_color_map(json) if break_property

      json[:features].each do |feature|
        feature = fix_feature(feature) if feature[:type] != 'Feature'

        mapped_attributes.each do |key, value|
          if key == :dataAttributes && mapped_attributes[:dataAttributes].is_a?(Array)
            # feature[:properties][:dataAttributes] = feature[:properties][value[0]]
            feature[:properties][:dataAttributes] = {}
            mapped_attributes[:dataAttributes].each do |datum|
              feature[:properties][:dataAttributes][datum] = feature[:properties][datum]
            end
          elsif key == :colorMap
            break_value = feature[:properties][break_property]
            if mapped_attributes[:colorMap].is_a?(Hash) && mapped_attributes[:colorMap][:steps].nil?
              feature[:properties][:color] = mapped_attributes[:colorMap][break_value.to_sym][:color]
            else
              json[:colorMap].each do |step|
                feature[:properties][:color] = step[:color] if break_value.between?(step[:bottom], step[:top])
              end
            end
          else
            feature[:properties][key] = sanitize_value(feature[:properties][value])
          end
        end
      end
      return json
    end
  end

  #
  # Create a new VectorLayer
  #
  # @param [Hash] options geojson, title and description for new VectorLayer
  #
  # @return [VectorLayer] newly created VectorLayer object.
  #
  def make_vector_layer(options)
    geojson, title, description = options.values_at(:geojson, :title, :description)
    geojson = JSON.parse(geojson) if geojson.is_a?(String)
    geojson = geojson.with_indifferent_access
    geojson = check_for_break(geojson) if geojson['breakProperty']
    layer = VectorLayer.create!(
      tmp_geojson: geojson,
      name: SecureRandom.uuid,
      title: title,
      description: description,
      institution: Institution.second,
      data_format: 'geojson',
      active: true,
      default_break_property: geojson['breakProperty'],
      color_map: geojson['colorMap']
    )
    return layer
  end

  private

  #
  # Calculate color map based on data if the number of steps is provided.
  # Otherwise, return the color map already defined.
  #
  # @return [Hahs] Instructions for how to color each feature.
  #
  def build_color_map(json)
    json[:breakProperty] = sanitize_value(break_property)

    return mapped_attributes[:colorMap] if mapped_attributes[:colorMap][:steps].nil?

    return ColorMap.new(
      geojson: json,
      property: break_property,
      steps: Integer(mapped_attributes[:colorMap][:steps]),
      brewer_scheme: mapped_attributes[:colorMap][:brew]
    ).create_map
  end

  def unzip
    destination = file.to_path.gsub('.zip', '')
    FileUtils.mkdir_p(destination)
    Zip::File.open(file) do |zip_file|
      zip_file.each do |entry|
        file_path = File.join(destination, entry.name)
        begin
          zip_file.extract(entry, file_path)
        rescue Errno::ENOENT
          next
        end
        next unless entry.name.ends_with?('.shp')

        self.file = file_path
      end
    end
  end

  def set_file_name
    self.file_name = title.parameterize
  end

  #
  # <Description>
  #
  # @return [<Type>] <description>
  #
  def to_geojson
    new_file_path = file.gsub('.shp', '.json')
    system("ogr2ogr -f  'GeoJSON' -t_srs EPSG:4326 #{new_file_path} '#{file}'")
    return new_file_path
  end

  def attributes_from_shape
    attrs = []
    features = []
    begin
      RGeo::Shapefile::Reader.open(file).each do |feature|
        attrs.concat(feature.attributes.map { |key, _value| key })
        features.push(feature.attributes)
      end
    rescue Errno::ENOENT => _e
      raise(VectorUploadException, 'Zip files must contain .shp file.')
    end

    return { attributes: attrs.uniq, data: features }
  end

  def attributes_from_spreadsheet
    spreadsheet = Roo::Spreadsheet.open(file, { csv_options: { encoding: 'bom|utf-8' } })
    rows = spreadsheet.is_a?(Roo::CSV) ? spreadsheet.parse(headers: true) : spreadsheet.sheet(0).parse(headers: true)
    data = rows.filter_map { |row| { properties: row } if row.values.any? { |v| v.present? } }
    return { attributes: rows.first.keys.compact, data: data }
  end

  def attributes_from_json
    attrs = []
    data = File.read(file)
    json = JSON.parse(data)

    json['features'].each do |feature|
      attrs.concat(feature['properties'].map { |key, _value| key })
    end

    return { attributes: attrs.uniq, data: json['features'] }
  end

  # rubocop:disable Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def build_geojson
    geojson = { type: 'FeatureCollection', features: [] }
    spreadsheet = Roo::Spreadsheet.open(file, { csv_options: { encoding: 'bom|utf-8' } })
    rows = spreadsheet.is_a?(Roo::CSV) ? spreadsheet.parse(headers: true) : spreadsheet.sheet(0).parse(headers: true)
    rows.each_with_index do |row, index|
      next if index.zero?

      next if row[mapped_attributes[:longitude]].nil? || row[mapped_attributes[:latitude]].nil?

      feature = empty_feature
      feature[:properties] = row.transform_keys(&:to_sym)
      mapped_attributes.each do |key, value|
        case key
        when :longitude
          lng = get_coordinates(row[value])
          next if row[value].nil?

          feature[:geometry][:coordinates][0] = lng
        when :latitude
          lat = get_coordinates(row[value])
          next if row[value].nil?

          feature[:geometry][:coordinates][1] = lat
        when :colorMap
          next
        # when :break
        #   feature[:]
        else
          feature[:properties][key.to_sym] = sanitize_value(row[value])
        end
      end
      geojson[:features].push(feature)
    end
    geojson = geojson.with_indifferent_access
    if mapped_attributes[:colorMap]
      geojson[:colorMap] = build_color_map(geojson)
      # geojson[:features].each do |feature|
      #   break_value = feature[:properties][break_property.to_sym]
      #   if mapped_attributes[:colorMap].is_a?(Hash) && mapped_attributes[:colorMap][:steps].nil?
      #     feature[:properties][:color] = mapped_attributes[:colorMap][break_value.to_sym][:color]
      #   else
      #     geojson[:colorMap].each do |step|
      #       feature[:properties][:color] = step[:color] if break_value.between?(step[:bottom], step[:top])
      #     end
      #   end
      # end
    end

    return geojson
  end

  def empty_feature
    return {
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: [0, 0]
      },
      properties: {}
    }
  end

  def get_coordinates(num)
    Float(num)
  rescue ArgumentError
    raise(VectorUploadException, "Values for longitude and latitude must be numbers. You provided #{num}")
  end

  def check_for_break(geojson)
    geojson['features'].each do |feature|
      feature['properties']['breakProperty'] = geojson['breakProperty']
      feature['properties']['breakValue'] = feature['properties'][geojson['breakProperty']]
    end
    return geojson
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

#
# Exception class for Vector Upoads
#
class VectorUploadException < StandardError
  #
  # <Description>
  #
  # @param [<Type>] msg <description>
  # @param [<Type>] exception_type <description>
  #
  def initialize(msg = 'This is a custom exception', exception_type = 'validation')
    @exception_type = exception_type
    super(msg)
  end
end
