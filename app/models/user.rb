class User < ActiveRecord::Base
    # # Include default devise modules. Others available are:
    # # :confirmable, :lockable, :timeoutable and :omniauthable
    # #
    # # devise :database_authenticatable, :registerable,
    # #        :recoverable, :rememberable, :trackable, :validatable
    #
    # # devise :omniauthable, omniauth_providers: [:facebook]
    has_one :login
    #
    belongs_to :institution
    #
    has_many :collaboration
    has_many :projects, through: :collaboration, dependent: :destroy
    has_many :user_tagged, dependent: :destroy
    #
    # # def self.from_omniauth(auth)
    # #     where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    # #         user.email = auth.info.email
    # #         user.password = Devise.friendly_token[0, 20]
    # #         # user.name = auth.info.name   # assuming the user model has a name
    # #         # user.image = auth.info.image # assuming the user model has an image
    # #         # If you are using confirmable and the provider(s) you use validate emails,
    # #         # uncomment the line below to skip the confirmation emails.
    # #         # user.skip_confirmation!
    # #     end
    # # end
    #
    def number_tagged
        user_tagged.count
    end

    def create
        user = User.new(user_params)
        if user.save && user.create_login(login_params)
            head 200
        else
            head 422 # you'd actually want to return validation errors here
        end
    end

    private

    def user_params
        params.require(:user).permit(:first_name, :last_name)
    end

    def login_params
        params.require(:user).permit(:identification, :password, :password_confirmation)
    end
end
