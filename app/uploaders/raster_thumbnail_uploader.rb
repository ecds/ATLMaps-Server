# app/uploaders/raster_thumbnail_uploader.rb
class RasterThumbnailUploader < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick

    # Let's use S3 for fun
    storage :fog

    # Override the directory where uploaded files will be stored.
    # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
        'raster-thumbnails'
    end

    process resize_to_fill: [500, 500]

    # Add a white list of extensions which are allowed to be uploaded.
    # For images you might use something like this:
    def extension_whitelist
        %w[png]
    end
end
