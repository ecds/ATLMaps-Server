# Model class for a User.
class User < ActiveRecord::Base
    has_one :login
    belongs_to :institution
    has_many :collaboration
    has_many :projects, through: :collaboration, dependent: :destroy
    has_many :user_tagged, dependent: :destroy

    # def number_tagged
    #     user_tagged.count
    # end

    def confirmed
        return login.provider.present? || \
               login.provider.nil? && login.confirm_token.nil?
    end

    def confirmation_token
        return unless login.confirm_token.blank?
        login.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
end
