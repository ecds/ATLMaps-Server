# app/uploaders/featured_card_uploader.rb
class FeaturedCardUploader < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick

    # Let's use S3 for fun
    storage :fog

    # Override the directory where uploaded files will be stored.
    # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
        "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    # Provide a default URL as a default if there hasn't been a file uploaded:
    # def default_url
    #   # For Rails 3.1+ asset pipeline compatibility:
    #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name,
    #   "default.png"].compact.join('_'))
    #
    #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
    # end

    # Process files as they are uploaded:
    process resize_to_fit: [500, 500]

    # Create different versions of your uploaded files:
    version :phone do
        process resize_to_fill: [50, 50]
    end

    version :tablet do
        process resize_to_fill: [200, 200]
    end

    # Add a white list of extensions which are allowed to be uploaded.
    # For images you might use something like this:
    def extension_white_list
        %w(jpg jpeg gif png)
    end
end
