# frozen_string_literal: true

namespace :dbfoo do
  desc 'FOO'
  task doit: :environment do
    layers = RasterLayer.all
    layers.each do |layer|
      name = layer.title
      title = layer.name
      layer.title = title
      layer.name = name
      layer.save
      puts layer.name
    end
  end
  task year: :environment do
    r_layers = RasterLayer.all
    r_layers.each do |rlayer|
      prng = Random.new
      rlayer.year = prng.rand(1864..2015)
      puts rlayer.year
      rlayer.save
    end
    v_layers = VectorLayer.all
    v_layers.each do |vlayer|
      prng = Random.new
      vlayer.year = prng.rand(1864..2015)
      puts vlayer.year
      vlayer.save
    end
  end
  task switchname: :environment do
    require 'securerandom'
    layers = VectorLayer.all
    layers.each do |layer|
      # puts SecureRandom.hex(2)
      title = layer.name
      layer.title = title
      layer.name = "p#{SecureRandom.hex(2)}"
      layer.save
      puts layer.title
    end
  end
  task tag: :environment do
    vectors = VectorLayer.all
    vectors.each do |vector|
      tag_ids = Array.new(4) { rand(1...37) }
      vector.tag_ids = tag_ids
      vector.save
    end
    rasters = RasterLayer.all
    rasters.each do |raster|
      tag_ids = Array.new(4) { rand(1...37) }
      raster.tag_ids = tag_ids
      raster.save
    end
  end

  task data_format: :environment do
    vectors = VectorLayer.all
    vectors.each do |vector|
      vector.tmp_type = vector.data_format
      vector.data_format = 'vector'
      vector.save
    end

    rasters = RasterLayer.all
    rasters.each do |raster|
      raster.tmp_type = raster.data_format
      raster.data_format = 'raster'
      raster.save
    end
  end

  task proj_data_format: :environment do
    vectors = VectorLayerProject.all
    vectors.each do |vector|
      vector.data_format = 'vector'
      vector.save
    end
    rasters = RasterLayerProject.all
    rasters.each do |raster|
      raster.data_format = 'raster'
      raster.save
    end
  end

  task set_vector_type: :environment do
    vectors = VectorLayer.all
    vectors.each do |vector|
      vector.tmp_type = 'point-data'
      vector.save
    end
  end

  task geogson_extents: :environment do
    # This is only for if you use the node package `gesjsonextents`
    # to get the boundingbox. Not really needed now that the features
    # are in the database.
    Dir.glob('data/*json') do |j|
      puts j
      f = File.open(j, 'r')
      bb = f.read
      puts bb
      bb = bb.tr(']', '')
      bb = bb.tr('[', '')
      bb = bb.split(',')
      vs = VectorLayer.ransack(url_end: j[5..-1])
      v = vs.result[0]
      v.minx = bb[0].to_f.round(8)
      v.miny = bb[1].to_f.round(8)
      v.maxx = bb[2].to_f.round(8)
      v.maxy = bb[3].to_f.round(8)
      v.save
    end
  end

  task set_raster_bounds: :environment do
    factory = RGeo::Geographic.simple_mercator_factory.projection_factory
    puts factory
    RasterLayer.all.each do |r|
      r.boundingbox = factory.polygon(
        factory.line_string(
          [
            factory.point(r.maxx, r.maxy),
            factory.point(r.minx, r.maxy),
            factory.point(r.minx, r.miny),
            factory.point(r.maxx, r.miny),
            factory.point(r.maxx, r.maxy)
          ]
        )
      )
      r.save
    end
  end

  task set_vector_bounds: :environment do
    # DO NOT USE!!!
    # USE vector_boundingbox INSTEAD
    factory = RGeo::Geographic.simple_mercator_factory.projection_factory
    VectorLayer.active.each do |v|
      # For now we are skipping single point layers because they
      # do not have an area.
      next unless v.vector_feature.length > 1

      puts v.id
      v.boundingbox = factory.polygon(
        factory.line_string(
          [
            factory.point(v.maxx, v.maxy),
            factory.point(v.minx, v.maxy),
            factory.point(v.minx, v.miny),
            factory.point(v.maxx, v.miny),
            factory.point(v.maxx, v.maxy)
          ]
        )
      )
      puts v.boundingbox.area
    end
  end

  # vf.geometry_collection.geometry_n(0).tmp_type.to_s.underscore

  task import_geojson_features: :environment do
    factory = RGeo::Geographic.simple_mercator_factory
    VectorLayer.active.each do |v|
      puts v.id
      next unless v.url

      geoj = JSON.load(open(v.url))
      geom = RGeo::GeoJSON.decode(geoj, json_parser: :json)
      geom.each do |feature|
        VectorFeature.create(
          properties: feature.properties,
          tmp_type: feature.geometry.tmp_type,
          geometry_collection: factory.collection([feature.geometry]),
          vector_layer: v
        )
      end
    end
  end

  task convert_geo_types: :environment do
    VectorFeature.all.each do |vf|
      geometry = vf.geometry_collection.geometry_n(0)
      vf.public_send("#{geometry.tmp_type.to_s.underscore}=", geometry)
      vf.save
    end
  end

  task vector_boundingbox: :environment do
    VectorLayer.all.each do |v|
      # For now we are skipping single point layers because they
      # do not have an un.
      next unless v.vector_feature.length > 1

      group = v.vector_feature[0].public_send(v.tmp_type.downcase)
      v.vector_feature.drop(1).each do |vf|
        group = group.union(vf.public_send(v.tmp_type.downcase))
      end
      v.boundingbox = group.envelope
      v.save
    end
  end

  task remote_vector_boundingbox: :environment do
    VectorLayer.all.each do |v|
      # For now we are skipping single point layers because they
      # do no have an un.
      next if v.vector_feature.length > 1
      next if v.url.nil?

      factory = RGeo::Geographic.simple_mercator_factory.projection_factory
      features = []
      geoj = JSON.parse(open(v.url).read)
      geom = RGeo::GeoJSON.decode(geoj, json_parser: :json)
      next unless geom.count > 2

      geom.each do |feature|
        features.push(factory.collection([feature.geometry]))
      end
      geom = nil
      group = features[0]
      features.drop(1).each do |f|
        group = group.union(f)
      end
      v.boundingbox = group.envelope
      bb = RGeo::Cartesian::BoundingBox.create_from_geometry(factory.collection([v.boundingbox]))
      v.maxx = bb.max_x
      v.maxy = bb.max_y
      v.minx = bb.min_x
      v.miny = bb.min_y
      p v.title
      p v.maxx
      p v.boundingbox
      # v.save
    end
  end

  task make_thumbnails: :environment do
    require 'httparty'
    factory = RGeo::Geographic.simple_mercator_factory.projection_factory

    RasterLayer.all.each do |r|
      next unless r.thumb.file.nil?

      # Zoom 17: http://wiki.openstreetmap.org/wiki/Zoom_levels
      neighborhood = { min_width: 1501, max_width: 9000, scale: 1.193 }
      # Cut out the ouside of the map with the hope that the thumbnil will
      # look more interesting.
      xdiff = (r.maxx - r.minx) * 0.25
      ydiff = (r.maxy - r.miny) * 0.25
      width = factory.point(r.maxx, r.maxy).distance(factory.point(r.minx, r.maxy)).to_f
      height = factory.point(r.minx, r.miny).distance(factory.point(r.minx, r.maxy)).to_f

      # So the downloaded images aren't crazy big, we cap the width or height
      # to 1500 pi
      if width > 1500.00 || height > 1500.00
        if width > height
          height = 1500.00 / (width / height)
          width = 1500.00
        else
          width = 1500.00 / (height / width)
          height = 1500.00
        end
      end

      size = { width: (width / neighborhood[:scale].to_f).to_i, height: (height / neighborhood[:scale].to_f).to_i }

      request = "#{r.institution.geoserver}#{r.workspace}/wms?service=WMS&version=1.1.0&request=GetMap&layers=#{r.workspace}:#{r.name}&styles=&bbox=#{r.minx + xdiff},#{r.miny + ydiff},#{r.maxx - xdiff},#{r.maxy - ydiff}&width=#{size[:width]}&height=#{size[:height]}&srs=EPSG:3857&format=image%2Fpng"
      p request
      next unless HTTParty.get(request).headers['content-type'] == 'image/png'

      response = nil
      filename = "/data/tmp/#{r.name}.png"
      File.open(filename, 'wb') do |file|
        response =
          HTTParty.get(request, stream_body: true) do |fragment|
            file.write(fragment)
          end
        r.thumb = file
        r.save!
        file.close
      end
      # File.delete(filename)
    end
  end
end
