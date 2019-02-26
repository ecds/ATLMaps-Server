# app/models/project.rb
class Project < ApplicationRecord
    include RailsApiAuth::Authentication

    mount_uploader :card, FeaturedCardUploader

    belongs_to :user

    has_many :raster_layer_project, dependent: :destroy
    has_many :raster_layers, through: :raster_layer_project

    has_many :vector_layer_project, dependent: :destroy
    has_many :vector_layers, through: :vector_layer_project, dependent: :destroy

    has_many :collaboration
    has_many :users, through: :collaboration

    scope :featured, -> { where('featured IS true') }

    # TODO: We need a better way.
    # embedly_re = Regexp.new(/((http:\/\/(instagr\.am\/p\/.*|instagram\.com\/p\/.*|.*youtube\.com\/watch.*|.*\.youtube\.com\/v\/.*|youtu\.be\/.*|.*\.youtube\.com\/user\/.*|.*\.youtube\.com\/.*#.*\/.*|m\.youtube\.com\/watch.*|m\.youtube\.com\/index.*|.*\.youtube\.com\/profile.*|.*\.youtube\.com\/view_play_list.*|.*\.youtube\.com\/playlist.*|www\.youtube\.com\/embed\/.*|youtube\.com\/gif.*|www\.youtube\.com\/gif.*|www\.youtube\.com\/attribution_link.*|youtube\.com\/attribution_link.*|youtube\.ca\/.*|youtube\.jp\/.*|youtube\.com\.br\/.*|youtube\.co\.uk\/.*|youtube\.nl\/.*|youtube\.pl\/.*|youtube\.es\/.*|youtube\.ie\/.*|it\.youtube\.com\/.*|youtube\.fr\/.*|www\.vimeo\.com\/groups\/.*\/videos\/.*|www\.vimeo\.com\/.*|vimeo\.com\/groups\/.*\/videos\/.*|vimeo\.com\/.*|vimeo\.com\/m\/#\/.*|player\.vimeo\.com\/.*))|(https:\/\/(.*youtube\.com\/watch.*|.*\.youtube\.com\/v\/.*|youtu\.be\/.*|.*\.youtube\.com\/playlist.*|www\.youtube\.com\/embed\/.*|youtube\.com\/gif.*|www\.youtube\.com\/gif.*|www\.youtube\.com\/attribution_link.*|youtube\.com\/attribution_link.*|youtube\.ca\/.*|youtube\.jp\/.*|youtube\.com\.br\/.*|youtube\.co\.uk\/.*|youtube\.nl\/.*|youtube\.pl\/.*|youtube\.es\/.*|youtube\.ie\/.*|it\.youtube\.com\/.*|youtube\.fr\/.*|www\.vimeo\.com\/.*|vimeo\.com\/.*|player\.vimeo\.com\/.*)))/i)
    # default_scope { includes(:projectlayer) }
    # validates_format_of :media, :with => /(?:.be\/|\/watch\?v=|\/(?=p\/))([\w\/\-]+)/, :on => :create, if: 'media.present?'
    # validates :media, format: { with:  embedly_re,
    #                             message: 'Not a valid YouTube embed code.' }, if: 'media.present?'

    def slug
        return 'untitled' if name.nil?
        name.parameterize
    end

    def owner
        return user[:displayname]
    end

    def new_project
        return created_at == updated_at
    end

    def intro?
        return unless intro.nil? && media.nil? && photo.nil?
    end
end
