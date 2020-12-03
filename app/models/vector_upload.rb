# frozen_string_literal: true

#
# <Description>
#
class VectorUpload
  include ActiveModel::Model
  include ActiveModel::AttributeMethods

  attr_accessor :type, :file, :attributes, :mapped_attributes, :geojson, :title, :file_name

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

    set_file_name if title.present?
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
      json = JSON.parse(File.read(geojson))

      # rubocop:disable Style/MissingElse
      if mapped_attributes['break'].present?
        break_property = mapped_attributes.delete('break')
        json['breakProperty'] = validate_value(break_property)
      end
      # rubocop:enable Style/MissingElse

      json['features'].each do |feature|
        original_properties = feature['properties']
        feature['properties'] = { originalProperties: {} }

        original_properties.each do |key, _value|
          feature['properties'][:originalProperties][key] = validate_value(original_properties[key])
        end

        mapped_attributes.each do |key, value|
          feature['properties'][key] = validate_value(original_properties[value])
        end
      end
      return json
    end
  end

  #
  # <Description>
  #
  # @return [<Type>] <description>
  #
  def make_shapefile
    geojson_file = File.join('/data/tmp', "#{file_name}.json")
    FileUtils.mkdir_p(File.join('/data/tmp', file_name))
    new_shapefile = File.join('/data/tmp', file_name, "#{file_name}.shp")
    File.open(geojson_file, 'w') do |f|
      f.write(geojson)
      f.close
      system("ogr2ogr -f 'ESRI SHAPEFILE' #{new_shapefile} '#{f.path}'")
    end
  end

  #
  # <Description>
  #
  # @param [<Type>] options <description>
  #
  # @return [<Type>] <description>
  #
  def make_vector_layer(options)
    geojson, title, description = options.values_at(:geojson, :title, :description)
    layer = VectorLayer.create!(
      tmp_geojson: geojson,
      name: SecureRandom.uuid,
      title: title,
      description: description,
      institution: Institution.second,
      data_format: 'geojson'
    )
    layer.save!
    return layer
  end

  private

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
    begin
      RGeo::Shapefile::Reader.open(file).each do |feature|
        attrs.concat(feature.attributes.map { |key, _value| key })
      end
    rescue Errno::ENOENT => _e
      raise(VectorUploadException, 'Zip files must contain .shp file.')
    end

    return attrs
  end

  def attributes_from_spreadsheet
    spreadsheet = Roo::Spreadsheet.open(file)
    rows = spreadsheet.is_a?(Roo::CSV) ? spreadsheet.parse(headers: true) : spreadsheet.sheet(0).parse(headers: true)
    return rows.first.keys.compact
  end

  def attributes_from_json
    attrs = []
    data = File.read(file)
    json = JSON.parse(data)

    json['features'].each do |feature|
      attrs.concat(feature['properties'].map { |key, _value| key })
    end

    return attrs
  end

  def build_geojson
    geojson = { type: 'FeatureCollection', features: [] }
    spreadsheet = Roo::Spreadsheet.open(file)
    rows = spreadsheet.is_a?(Roo::CSV) ? spreadsheet.parse(headers: true) : spreadsheet.sheet(0).parse(headers: true)
    rows.each_with_index do |row, index|
      next if index.zero?

      next if row[mapped_attributes['longitude']].nil? || row[mapped_attributes['latitude']].nil?

      feature = empty_feature

      mapped_attributes.each do |key, value|
        case key
        when 'longitude'
          lng = get_coordinates(row[value])
          next if row[value].nil?
          feature[:geometry][:coordinates][0] = lng
        when 'latitude'
          lat = get_coordinates(row[value])
          next if row[value].nil?
          feature[:geometry][:coordinates][1] = lat
        else
          feature[:properties][key.to_sym] = validate_value(row[value])
        end
      end
      geojson[:features].push(feature)
    end
    return geojson
  end
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

def validate_value(value)
  sanitizer = Rails::Html::SafeListSanitizer.new
  # rubocop:disable Style/CaseLikeIf, Style/EmptyElse
  if value.is_a?(String)
    sanitizer.sanitize(value)
  elsif value.is_a?(Numeric)
    value
  else
    nil
  end
  # rubocop:enable Style/CaseLikeIf, Style/EmptyElse
end

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