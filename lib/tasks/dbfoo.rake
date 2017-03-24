namespace :dbfoo do
    desc "FOO"
    task doit: :environment do
        layers = RasterLayer.all()
        layers.each { |layer|
            name = layer.title
            title = layer.name
            layer.title = title
            layer.name = name
            layer.save
            puts layer.name
        }
    end
    task year: :environment do
        r_layers = RasterLayer.all()
        r_layers.each { |rlayer|
            prng = Random.new
            rlayer.year = prng.rand(1864..2015)
            puts rlayer.year
            rlayer.save
        }
        v_layers = VectorLayer.all()
        v_layers.each { |vlayer|
            prng = Random.new
            vlayer.year = prng.rand(1864..2015)
            puts vlayer.year
            vlayer.save
        }
    end
    task switchname: :environment do
        require 'securerandom'
        layers = VectorLayer.all()
        layers.each { |layer|
            # puts SecureRandom.hex(2)
            title = layer.name
            layer.title = title
            layer.name = "p#{SecureRandom.hex(2)}"
            layer.save
             puts layer.title
        }
    end
    task tag: :environment do
        vectors = VectorLayer.all()
        vectors.each { |vector|
            tag_ids = Array.new(4) { rand(1...37) }
            vector.tag_ids = tag_ids
            vector.save
        }
        rasters = RasterLayer.all()
        rasters.each { |raster|
            tag_ids = Array.new(4) { rand(1...37) }
            raster.tag_ids = tag_ids
            raster.save
        }
    end

    task data_format: :environment do
        vectors = VectorLayer.all()
        vectors.each { |vector|
            vector.data_type = vector.data_format
            vector.data_format = 'vector'
            vector.save
        }
        rasters = RasterLayer.all()
        rasters.each { |raster|
            raster.data_type = raster.data_format
            raster.data_format = 'raster'
            raster.save
        }

    end

    task proj_data_format: :environment do
        vectors = VectorLayerProject.all()
        vectors.each { |vector|
            vector.data_format = 'vector'
            vector.save
        }
        rasters = RasterLayerProject.all()
        rasters.each { |raster|
            raster.data_format = 'raster'
            raster.save
        }

    end

    task set_vector_type: :environment do
        vectors = VectorLayer.all()
        vectors.each { |vector|
            vector.data_type = 'point-data'
            vector.save
        }
    end
end