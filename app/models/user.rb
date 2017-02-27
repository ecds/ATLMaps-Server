class User < ActiveRecord::Base

    has_one :login
    belongs_to :institution
    has_many :collaboration
    has_many :projects, through: :collaboration, dependent: :destroy
    has_many :user_tagged, dependent: :destroy

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
end
