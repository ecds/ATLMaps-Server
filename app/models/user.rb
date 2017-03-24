# Model class for a User.
class User < ActiveRecord::Base
    has_one :login
    belongs_to :institution
    has_many :collaboration
    has_many :projects, through: :collaboration, dependent: :destroy
    has_many :user_tagged, dependent: :destroy

    def number_tagged
        user_tagged.count
    end

    def confirmed
        # Local users will not have a provider.
        return login.provider? || login.confirm_token.nil?
    end
end
