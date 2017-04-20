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
            vector.data_type = vector.data_format
            vector.data_format = 'vector'
            vector.save
        end

        rasters = RasterLayer.all
        rasters.each do |raster|
            raster.data_type = raster.data_format
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
            vector.data_type = 'point-data'
            vector.save
        end
    end

    task geogson_extents: :environment do
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
end
