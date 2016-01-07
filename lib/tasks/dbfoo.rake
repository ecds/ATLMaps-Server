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
end
